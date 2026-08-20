# =========================
# Frontend Build
# =========================

FROM node:20-alpine AS frontend-build

WORKDIR /app/client

COPY client/package*.json ./

RUN npm install

COPY client/ .

RUN npm run build


# =========================
# Frontend Production
# =========================

FROM nginx:alpine AS frontend

COPY --from=frontend-build /app/client/dist /usr/share/nginx/html

COPY Docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

# =========================
# Backend
# =========================

FROM node:20-alpine AS backend

WORKDIR /app/server

COPY server/package*.json ./

RUN npm install

COPY server/ .

EXPOSE 3000

CMD ["node", "index.js"]
