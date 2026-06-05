FROM node:22-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g openclaw@latest --omit=dev

ENV OPENCLAW_STATE_DIR=/root/.openclaw
ENV NODE_ENV=production
ENV PORT=10000

WORKDIR /app
EXPOSE 10000

# Fix: Drops complex manual JSON strings and uses official flags to force a public unconfigured boot
CMD mkdir -p /root/.openclaw/agents/dev/agent && \
    echo "{\"openai\": {\"apiKey\": \"$OPENAI_API_KEY\", \"baseURL\": \"https://openrouter.ai\"}}" > /root/.openclaw/agents/dev/agent/auth-profiles.json && \
    chmod -R 777 /root/.openclaw && \
    openclaw gateway start --allow-unconfigured
