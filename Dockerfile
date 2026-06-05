FROM node:22-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g openclaw@latest --omit=dev

ENV OPENCLAW_STATE_DIR=/root/.openclaw
ENV NODE_ENV=production
ENV PORT=10000

WORKDIR /app
EXPOSE 10000

# Fix: Explicitly injects allowedOrigins wildcards and arrays to bypass the security wall
CMD mkdir -p /root/.openclaw/agents/dev/agent && \
    echo "{\"openai\": {\"apiKey\": \"$OPENAI_API_KEY\", \"baseURL\": \"https://openrouter.ai\"}}" > /root/.openclaw/agents/dev/agent/auth-profiles.json && \
    echo "{\"gateway\": {\"mode\": \"local\", \"bind\": \"lan\", \"port\": 10000, \"auth\": {\"mode\": \"token\", \"token\": \"my_secret_password_123\"}, \"controlUi\": {\"allowedOrigins\": [\"*\", \"http://localhost:5173\", \"null\", \"vscode-webview://\"]}}}" > /root/.openclaw/openclaw.json && \
    chmod -R 777 /root/.openclaw && \
    openclaw gateway
