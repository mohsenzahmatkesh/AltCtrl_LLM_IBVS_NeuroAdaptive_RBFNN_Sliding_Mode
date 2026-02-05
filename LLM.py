#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb  4 15:16:42 2026

@author: mohsen
"""

import time
import os
import scipy.io as sio
import json
from openai import OpenAI # Or use Ollama client

# Setup client
client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama") # Example for local Ollama

def call_llm_agent(data):
    """Refines controller parameters using heuristic optimization[cite: 114]."""
    prompt = f"""
    You are an ACTOR in a multi-agent control framework.
    Task: Optimize gains for an IBVS SMC Tethered Hexarotor[cite: 197].
    
    Current Telemetry:
    - SSE: {data['SSE']}
    - Max Error: {data['max_err']}
    - Current Kp: {data['Kp']}
    
    Logic:
    - If SSE is high, increase Kp for faster response.
    - If chattering/vibration is suspected (High max error relative to SSE), increase Kd.
    
    Return ONLY a JSON: {{"Kp": float, "Kd": float, "Kq": float, "reasoning": "string"}}
    """
    
    response = client.chat.completions.create(
        model="deepseek-r1:70b", # DeepSeek achieved fast convergence in research [cite: 21, 406]
        messages=[{"role": "user", "content": prompt}],
        response_format={ "type": "json_object" }
    )
    return json.loads(response.choices[0].message.content)

print("LLM Bridge Active. Waiting for MATLAB telemetry...")

while True:
    if os.path.exists('telemetry.mat'):
        try:
            # 1. Load data from MATLAB
            mat_contents = sio.loadmat('telemetry.mat')
            tel_data = mat_contents['tel'][0,0]
            telemetry = {'SSE': float(tel_data[0]), 'max_err': float(tel_data[1]), 'Kp': float(tel_data[2])}
            
            # 2. Get LLM recommendation
            print(f"Analyzing Snapshot at SSE: {telemetry['SSE']}...")
            new_params = call_llm_agent(telemetry)
            
            # 3. Save struct for MATLAB
            sio.savemat('gains_from_llm.mat', {'new_gains': new_params})
            print(f"Updated gains: Kp={new_params['Kp']}. Reasoning: {new_params['reasoning']}")
            
            # Clean up to wait for next snapshot
            os.remove('telemetry.mat')
            
        except Exception as e:
            print(f"Error: {e}")
    
    time.sleep(2)