import time
import os
import scipy.io as sio
import json
from datetime import datetime
from openai import OpenAI


# Load .mat file
data = sio.loadmat("ibvs_errors.mat")

# Extract variables (as numpy arrays)
# SE  = data["SE"]
# SSE = data["SSE"]

# x1 = data["x1_err"]; y1 = data["y1_err"]
# x2 = data["x2_err"]; y2 = data["y2_err"]
# x3 = data["x3_err"]; y3 = data["y3_err"]
# x4 = data["x4_err"]; y4 = data["y4_err"]



# Build EMPTY prompt (you will write it)
prompt = ""

# LLM client (Ollama)
client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")
MODEL_NAME = "deepseek-r1:1.5b"

response = client.chat.completions.create(
    model=MODEL_NAME,
    messages=[{"role": "user", "content": prompt}]
)

print(response.choices[0].message.content)
