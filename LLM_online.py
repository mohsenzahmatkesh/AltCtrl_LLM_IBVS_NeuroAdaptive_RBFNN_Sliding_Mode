import time
import os
import scipy.io as sio
import json
from datetime import datetime
from openai import OpenAI

# 1. SETUP LOCAL CLIENT
client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")
MODEL_NAME = "deepseek-r1:1.5b" 

history = []

def log_reasoning(telemetry, sanitized):
    """Saves the LLM's logic to a file for your paper's results."""
    timestamp = datetime.now().strftime("%H:%M:%S")
    log_entry = (
        f"--- [{timestamp}] ---\n"
        f"METRICS: SSE={telemetry['SSE']:.2f}, MaxErr={telemetry['max_err']:.4f}\n"
        f"ACTION: Suggested Kp={sanitized['Kp']}, Kd={sanitized['Kd']}, Kq={sanitized['Kq']}\n"
        f"REASONING: {sanitized['reason'].strip()}\n\n"
    )
    with open("llm_decision_log.txt", "a") as f:
        f.write(log_entry)

def call_llm_agent(data):
    global history
    history.append(data['SSE'])
    if len(history) > 3: history.pop(0)
    
    # Prompt mimicking the 'Drone Control Engineer' persona from REAL paper [cite: 200]
    prompt = f"""
    [SYSTEM ROLE]
    You are a Senior Flight Control Engineer specializing in IBVS and Tethered Hexarotor dynamics. 
    
    [CONTROL OBJECTIVE]
    Minimize SSE (< 0.2) and stabilize altitude despite unmodeled tether tension.
    
    [STATE TELEMETRY]
    - Current Gains: Kp={data['Kp']:.2f}
    - Current Metrics: SSE={data['SSE']:.2f}, Max Error={data['max_err']:.4f}
    - Performance History (Last 3 SSE): {history}
    
    [TASK]
    1. ANALYZE: Compare current SSE to history. Is the system converging or stalled?
    2. DIAGNOSE: Does the high SSE indicate low proportional gain or external bias?
    3. PROPOSE: Suggest new gains: Kp [14-16], Kd [6.5-8.5], Kq [0.7-0.9].
    4. JUSTIFY: Provide a technical rationale (e.g., "Increasing Kp to overcome tether-induced steady-state bias").
    
    [OUTPUT FORMAT]
    Return ONLY a JSON object with this structure:
    {{
      "Kp": float, 
      "Kd": float, 
      "Kq": float, 
      "msg": "Step-by-step reasoning (Max 250 chars)"
    }}
    """
    try:
        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=[{"role": "user", "content": prompt}],
            response_format={ "type": "json_object" },
            timeout=15.0 
        )
        return json.loads(response.choices[0].message.content)
    except Exception as e:
        print(f"  Reasoning Error: {e}")
        return {"Kp": 15.0, "Kd": 7.5, "Kq": 0.8, "msg": "Fallback: API Error"}

print(f"Agentic Bridge Active. Logging decisions to 'llm_decision_log.txt'...")

while True:
    if os.path.exists('telemetry.mat'):
        try:
            time.sleep(0.1) 
            mat = sio.loadmat('telemetry.mat')
            raw_tel = mat['tel'][0,0]
            
            telemetry = {
                'SSE': float(raw_tel['SSE'].item()),
                'max_err': float(raw_tel['max_err'].item()),
                'Kp': float(raw_tel['Kp'].item())
            }
            
            # Get reasoning and gains
            new_params = call_llm_agent(telemetry)
            
            # Sanitize and Pad for MATLAB Coder stability
            reason_str = str(new_params.get('msg', 'tuning'))[:100]
            reason_fixed = reason_str.ljust(100) 
            
            sanitized = {
                'Kp': float(new_params.get('Kp', 15.0)),
                'Kd': float(new_params.get('Kd', 7.5)),
                'Kq': float(new_params.get('Kq', 0.8)),
                'reason': reason_fixed 
            }

            # 1. Save to MAT for Simulink
            sio.savemat('gains_from_llm.mat', {'new_gains': sanitized})
            
            # 2. Save to LOG for you to read
            log_reasoning(telemetry, sanitized)
            
            print(f"[Snapshot] SSE: {telemetry['SSE']:.2f} -> Logged.")
            os.remove('telemetry.mat')
            
        except Exception as e:
            if "truncated" not in str(e).lower():
                print(f"Bridge Error: {e}")
            
    time.sleep(0.5)