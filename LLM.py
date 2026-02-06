import time
import os
import scipy.io as sio
import json
from openai import OpenAI

# 1. SETUP CLIENT
client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")
# MATCH THIS EXACTLY TO YOUR 'ollama list' OUTPUT
MODEL_NAME = "deepseek-r1:1.5b" 

# Track history to identify if progress is stalled (LLMTerminator logic)
history = []

def call_llm_agent(data):
    global history
    history.append(data['SSE'])
    if len(history) > 3: history.pop(0) # Keep last 3 iterations
    
    # The prompt now includes the trend to help the 'Critic' evaluate performance
    prompt = f"""
    SYSTEM: Tethered Hexarotor IBVS.
    GOAL: SSE < 0.2.
    HISTORY (Last 3 SSE): {history}
    CURRENT: SSE={data['SSE']:.2f}, Kp={data['Kp']:.2f}.
    
    TASK: If SSE is stalled or high, suggest a much higher Kp (Range 10-60). 
    If chattering occurs, increase Kd.
    
    OUTPUT ONLY JSON: {{"Kp": float, "Kd": float, "Kq": float, "msg": "str"}}
    """
    try:
        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=[{"role": "user", "content": prompt}],
            response_format={ "type": "json_object" },
            timeout=12.0 
        )
        return json.loads(response.choices[0].message.content)
    except Exception as e:
        print(f"  Agent Delay: {e}")
        # Default safety action: Increment Kp if LLM fails
        return {"Kp": data['Kp'] + 2.0, "Kd": 5.0, "Kq": 0.5, "msg": "Fallback"}

print(f"Agentic Bridge Active using {MODEL_NAME}...")

while True:
    if os.path.exists('telemetry.mat'):
        try:
            # Short wait to avoid 'truncated file' errors
            time.sleep(0.1) 
            mat = sio.loadmat('telemetry.mat')
            raw_tel = mat['tel'][0,0]
            
            telemetry = {
                'SSE': float(raw_tel['SSE'].item()),
                'max_err': float(raw_tel['max_err'].item()),
                'Kp': float(raw_tel['Kp'].item())
            }
            
            # Agent Loop: Propose -> Evaluate (Actor-Critic)
            new_params = call_llm_agent(telemetry)
            
            # Guardrail: Limit string length for MATLAB compatibility
            sanitized = {
                'Kp': float(new_params.get('Kp', 15.0)),
                'Kd': float(new_params.get('Kd', 5.0)),
                'Kq': float(new_params.get('Kq', 0.5)),
                'reason': str(new_params.get('msg', 'tuning'))[:25]
            }

            sio.savemat('gains_from_llm.mat', {'new_gains': sanitized})
            print(f"[Snapshot] SSE: {telemetry['SSE']:.2f} -> [Action] Suggested Kp: {sanitized['Kp']}")
            
            os.remove('telemetry.mat')
            
        except Exception as e:
            if "truncated" not in str(e).lower():
                print(f"Bridge Error: {e}")
            
    time.sleep(0.5) 