FROM node:22-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g openclaw@latest --omit=dev

ENV NODE_ENV=production
ENV OPENCLAW_GATEWAY_PORT=10000
ENV PORT=10000
ENV OPENCLAW_GATEWAY_BIND=0.0.0.0
ENV OPENCLAW_STATE_DIR=/opt/render/.openclaw

WORKDIR /app
EXPOSE 10000

# This configuration file explicitly locks the host to 0.0.0.0 so Render can detect the port
CMD mkdir -p /opt/render/.openclaw/agents/dev/agent && \
    echo "{\"openai\": {\"apiKey\": \"$OPENAI_API_KEY\", \"baseURL\": \"https://openrouter.ai\"}}" > /opt/render/.openclaw/agents/dev/agent/auth-profiles.json && \
    mkdir -p /opt/render/.openclaw/config && \
    echo "{\"gateway\": {\"host\": \"0.0.0.0\", \"port\": 10000, \"auth\": {\"mode\": \"token\", \"token\": \"UsmanAgent@412044\"}}}" > /opt/render/.openclaw/config/gateway.json && \
    chmod -R 777 /opt/render/.openclaw && \
    openclaw gateway --dev
