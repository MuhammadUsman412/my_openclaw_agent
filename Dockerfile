FROM node:22-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g openclaw@latest --omit=dev

ENV OPENCLAW_STATE_DIR=/root/.openclaw
ENV NODE_ENV=production
ENV PORT=10000

WORKDIR /app
EXPOSE 10000

# Fix: Sets mode back to local, overrides proxies, and pre-approves your desktop device footprint
CMD mkdir -p /root/.openclaw/agents/dev/agent && \
    mkdir -p /root/.openclaw/config && \
    echo "{\"openai\": {\"apiKey\": \"$OPENAI_API_KEY\", \"baseURL\": \"https://openrouter.ai\"}}" > /root/.openclaw/agents/dev/agent/auth-profiles.json && \
    echo "{\"gateway\": {\"mode\": \"local\", \"bind\": \"lan\", \"port\": 10000, \"trustProxy\": true, \"auth\": {\"mode\": \"token\", \"token\": \"UsmanAgent@412044\"}, \"controlUi\": {\"allowedOrigins\": [\"*\", \"http://localhost:5173\", \"null\", \"vscode-webview://\"]}}}" > /root/.openclaw/openclaw.json && \
    echo "{\"devices\": {\"23a6829e-7a39-4f6d-8167-cdf721350165\": {\"id\": \"23a6829e-7a39-4f6d-8167-cdf721350165\", \"name\": \"Windows Companion\", \"approved\": true, \"addedAt\": 1717571811000}}}" > /root/.openclaw/devices.json && \
    chmod -R 777 /root/.openclaw && \
    openclaw gateway
