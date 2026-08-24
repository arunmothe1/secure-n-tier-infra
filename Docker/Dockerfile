FROM node:20-bookworm AS client-build

WORKDIR /app/client

COPY application/client/package*.json ./
RUN npm install

COPY application/client/ ./
RUN npm run build

FROM node:20-bookworm

WORKDIR /app

RUN apt-get update \
    && apt-get install -y nginx supervisor \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/server

COPY application/server/package*.json ./
RUN npm install --omit=dev

COPY application/server/ ./

COPY --from=client-build /app/client/dist /usr/share/nginx/html

COPY Docker/nginx.conf /etc/nginx/nginx.conf
COPY Docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 3000

CMD ["/usr/bin/supervisord", "-n"]