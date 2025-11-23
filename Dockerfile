FROM node:22-bullseye

ENV PNPM_HOME=/root/.local/share/pnpm \
    NODE_ENV=production
RUN corepack enable

WORKDIR /app

ARG POSTIZ_REPO=https://github.com/gitroomhq/postiz-app.git
ARG POSTIZ_REF=main

RUN apt-get update && apt-get install -y git python3 build-essential && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 -b ${POSTIZ_REF} ${POSTIZ_REPO} /tmp/postiz

COPY speakeasy.env /tmp/speakeasy.env

RUN cp -r /tmp/postiz/. /app/ && rm -rf /tmp/postiz && \
    cp /tmp/speakeasy.env /app/.env.speakeasy && rm /tmp/speakeasy.env

RUN pnpm install --frozen-lockfile && pnpm build:backend

EXPOSE 4455

CMD ["pnpm","start:prod:backend"]
