FROM node:22-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g openclaw@latest --omit=dev

# System and storage states
ENV NODE_ENV=production
ENV OPENCLAW_STATE_DIR=/root/.openclaw

# CRITICAL FIX: Direct OpenClaw framework overrides using native environment variables
ENV OPENCLAW_GATEWAY_PORT=10000
ENV PORT=10000
ENV OPENCLAW_GATEWAY_BIND=lan

# Bypasses device pairing and origin firewalls safely at the system layer
ENV OPENCLAW_GATEWAY_DEV_AUTO_APPROVE_DEVICES=true

WORKDIR /app
EXPOSE 10000

# Pristine baseline startup command with no conflicting sub-flags
CMD mkdir -p /root/.openclaw/agents/dev/agent && \
    echo "{\"openai\": {\"apiKey\": \"$OPENAI_API_KEY\", \"baseURL\": \"https://openrouter.ai\"}}" > /root/.openclaw/agents/dev/agent/auth-profiles.json && \
    chmod -R 777 /root/.openclaw && \
    openclaw gateway
