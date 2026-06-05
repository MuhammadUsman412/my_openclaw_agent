FROM python:3.11-slim

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Ensure the port matches the one in render.yaml
EXPOSE 8080

# Replace 'main.py' with your actual entry point script
CMD ["python", "main.py"]
