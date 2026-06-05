FROM node:22-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g openclaw@latest --omit=dev

ENV OPENCLAW_STATE_DIR=/root/.openclaw
ENV NODE_ENV=production
ENV PORT=10000

ENV OPENCLAW_GATEWAY_DEV_AUTO_APPROVE_DEVICES=true

WORKDIR /app
EXPOSE 10000

CMD mkdir -p /root/.openclaw/agents/dev/agent && \
    echo "{\"openai\": {\"apiKey\": \"$OPENAI_API_KEY\", \"baseURL\": \"https://openrouter.ai\"}}" > /root/.openclaw/agents/dev/agent/auth-profiles.json && \
    echo "{\"gateway\": {\"mode\": \"local\", \"bind\": \"lan\", \"port\": 10000, \"auth\": {\"mode\": \"token\", \"token\": \"UsmanAgent@412044\"}, \"controlUi\": {\"dangerouslyAllowHostHeaderOriginFallback\": true, \"allowedOrigins\": [\"app://localhost\", \"http://localhost:5173\", \"vscode-webview://\", \"null\"]}}}" > /root/.openclaw/openclaw.json && \
    chmod -R 777 /root/.openclaw && \
    openclaw gateway

