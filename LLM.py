#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb  4 15:16:42 2026

@author: mohsen
"""

import time
import json
import openai # or use 'ollama' for local LLMs

def call_llm_agent(telemetry_data):
    prompt = f"""
    System: Tethered Hexarotor IBVS Controller.
    Status: 
    - SSE: {telemetry_data['SSE']}
    - Image Error: {telemetry_data['error']}
    - Current Kp: {telemetry_data['Kp']}
    
    Task: If SSE is rising, increase Kp slightly. If SSE is low but 
    vibration (chattering) is high, decrease Kq.
    Constraint: Kp must be between 5 and 50. Kq must be between 0.01 and 5.0.
    Return ONLY JSON: {{"Kp": float, "Kd": float, "Kq": float, "Reason": "string"}}
    """
    # API Call logic here...
    return {"Kp": 18.5, "Kd": 8.0, "Kq": 0.8} # Example response

while True:
    try:
        with open('telemetry.json', 'r') as f:
            data = json.load(f)
        
        new_gains = call_llm_agent(data)
        
        with open('gains_from_llm.json', 'w') as f:
            json.dump(new_gains, f)
            
        print("Updated gains sent to MATLAB.")
        time.sleep(5) # Wait for next update cycle
    except FileNotFoundError:
        time.sleep(1)