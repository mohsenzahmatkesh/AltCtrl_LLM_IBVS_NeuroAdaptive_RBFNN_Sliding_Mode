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
from openai import OpenAI

# SETUP: Local Ollama or OpenAI
client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")
MODEL = "deepseek-r1:70b" # DeepSeek is recommended for fast convergence [cite: 21, 406]

def call_llm_agent(data):
    prompt = f"""
    You are the Actor/Critic in a control optimization framework. [cite: 67]
    Current SSE: {data['SSE']:.2f}, Max Error: {data['max_err']:.2f}, Kp: {data['Kp']:.2f}. [cite: 176]
    If SSE is high, increase Kp. If chattering is present, adjust Kq. [cite: 173]
    Return ONLY JSON: {{"Kp": float, "Kd": float, "Kq": float}} 
    """
    try:
        response = client.chat.completions.create(
            model=MODEL,
            messages=[{"role": "user", "content": prompt}],
            response_format={ "type": "json_object" }
        )
        return json.loads(response.choices[0].message.content)
    except Exception as e:
        print(f"LLM Error: {e}")
        return None

print("LLM Bridge Active. Waiting for MATLAB telemetry...")

while True:
    if os.path.exists('telemetry.mat'):
        try:
            # Load the .mat file
            mat = sio.loadmat('telemetry.mat')
            
            # ACCESS THE CORRECT KEY: 'stats_data'
            raw_stats = mat['stats_data'][0,0]
            
            # Extract values precisely as floats
            telemetry = {
                'SSE': float(raw_stats['SSE'].item()),
                'max_err': float(raw_stats['max_err'].item()),
                'Kp': float(raw_stats['Kp'].item())
            }
            
            print(f"Iteration Data: SSE={telemetry['SSE']:.2f}, Kp={telemetry['Kp']:.2f}") [cite: 172]
            
            # Get Agent Recommendation
            new_params = call_llm_agent(telemetry)
            
            if new_params:
                # Save as 'new_gains' for MATLAB
                sio.savemat('gains_from_llm.mat', {'new_gains': new_params})
                print(f"Action: Parameters refined. [cite: 173] Kp set to {new_params['Kp']}")
            
            os.remove('telemetry.mat') # Signal cycle completion [cite: 122]
            
        except Exception as e:
            print(f"Bridge Processing Error: {e}")
            
    time.sleep(2)