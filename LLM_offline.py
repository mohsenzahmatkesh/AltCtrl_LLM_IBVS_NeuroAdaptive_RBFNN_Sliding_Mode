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

prompt = "Return ONLY three numbers: Kp Kd Kq"

response = client.chat.completions.create(
    model=MODEL_NAME,
    messages=[{"role": "user", "content": prompt}]
)

print(response.choices[0].message.content)