import time
import os
import scipy.io as sio
import json
from datetime import datetime
from openai import OpenAI


data = sio.loadmat("ibvs_errors.mat", squeeze_me=True, struct_as_record=False)

tout = data["tout"]
SE   = data["SE"]
SSE  = data["SSE"]

x1 = data["x1_err"]; y1 = data["y1_err"]
x2 = data["x2_err"]; y2 = data["y2_err"]
x3 = data["x3_err"]; y3 = data["y3_err"]
x4 = data["x4_err"]; y4 = data["y4_err"]

SE_last  = float(SE[-1])
SE_mean  = float(SE.mean())
SSE_last = float(SSE[-1])
SSE_mean = float(SSE.mean())


overshoot = data["overshoot"]
settle    = data["settle"]


prompt = f"""
Overshoot (%):
x1: {overshoot.x1:.2f}, y1: {overshoot.y1:.2f}
x2: {overshoot.x2:.2f}, y2: {overshoot.y2:.2f}
x3: {overshoot.x3:.2f}, y3: {overshoot.y3:.2f}
x4: {overshoot.x4:.2f}, y4: {overshoot.y4:.2f}

Settling time (s):
x1: {settle.x1:.2f}, y1: {settle.y1:.2f}
x2: {settle.x2:.2f}, y2: {settle.y2:.2f}
x3: {settle.x3:.2f}, y3: {settle.y3:.2f}
x4: {settle.x4:.2f}, y4: {settle.y4:.2f}

Tracking error metrics:
SE  (final): {SE_last:.4f}
SE  (mean) : {SE_mean:.4f}
SSE (final): {SSE_last:.4f}
SSE (mean) : {SSE_mean:.4f}

Baseline controller gains:
Kp = 15, Kd = 7.5, Kq = 0.8

Objective:
Design a time-based (or phase-based) gain look-up table that minimizes overshoot, settling time, SE, and SSE simultaneously.
The new gains should improve tracking accuracy and damping compared to the baseline.

Instruction:
Analyze the data and suggest improved gains.
Return ONLY three numbers in this order:
Kp Kd Kq
"""







# LLM client (Ollama)
client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")
MODEL_NAME = "deepseek-r1:1.5b"

response = client.chat.completions.create(
    model=MODEL_NAME,
    messages=[{"role": "user", "content": prompt}]
)

# ---- FORMAT CHECK GOES HERE ----
txt = response.choices[0].message.content.strip()
lines = [ln.strip() for ln in txt.splitlines() if ln.strip()]

ok = (len(lines) == 5) and all(len(ln.split()) == 4 for ln in lines)

if not ok:
    print("Bad format from LLM:\n", txt)
    raise ValueError("LLM did not return 5 lines of 't_start Kp Kd Kq'")

# If format is correct, print it
print("Valid LUT:")
print(txt)

