FROM node:22-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g openclaw@latest --omit=dev

ENV OPENCLAW_STATE_DIR=/root/.openclaw
ENV NODE_ENV=production
ENV PORT=10000

WORKDIR /app
EXPOSE 10000

# Fix: Passes the exact full app origins (including app://localhost) and the true dangerous fallback fallback key safely inside the configuration profile
CMD mkdir -p /root/.openclaw/agents/dev/agent && \
    echo "{\"openai\": {\"apiKey\": \"$OPENAI_API_KEY\", \"baseURL\": \"https://openrouter.ai\"}}" > /root/.openclaw/agents/dev/agent/auth-profiles.json && \
    echo "{\"gateway\": {\"mode\": \"local\", \"bind\": \"lan\", \"port\": 10000, \"auth\": {\"mode\": \"token\", \"token\": \"UsmanAgent@412044\"}, \"controlUi\": {\"dangerouslyAllowHostHeaderOriginFallback\": true, \"allowedOrigins\": [\"app://localhost\", \"http://localhost:5173\", \"vscode-webview://\", \"null\"]}}}" > /root/.openclaw/openclaw.json && \
    echo "{\"devices\": {\"b46fc636-1351-4f19-b191-1f0244b7d82d\": {\"id\": \"b46fc636-1351-4f19-b191-1f0244b7d82d\", \"name\": \"Windows Companion\", \"approved\": true, \"addedAt\": 1717571811000}}}" > /root/.openclaw/devices.json && \
    echo "{\"devices\": {\"b3cdb561-da8e-4c32-a9d6-f2b8303d2739\": {\"id\": \"b3cdb561-da8e-4c32-a9d6-f2b8303d2739\", \"name\": \"Windows Companion\", \"approved\": true, \"addedAt\": 1717571811000}}}" > /root/.openclaw/devices.json && \
    chmod -R 777 /root/.openclaw && \
    openclaw gateway
