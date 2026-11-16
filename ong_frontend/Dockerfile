# Frontend: build do Vite servido pelo nginx, que também faz proxy da API para o backend.
FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
# Variáveis VITE_* entram no build (são públicas: aparecem no JavaScript do navegador).
ARG VITE_GOOGLE_CLIENT_ID=""
ENV VITE_GOOGLE_CLIENT_ID=$VITE_GOOGLE_CLIENT_ID
RUN npm run build

FROM nginx:1.27-alpine
# A imagem oficial aplica /etc/nginx/templates/*.template (envsubst) ao iniciar.
# PORT: o Railway define; BACKEND_URL: endereço do Django (padrão do docker-compose).
ENV PORT=80
ENV BACKEND_URL=http://backend:8000
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY iniciar-nginx.sh /iniciar-nginx.sh
COPY --from=build /app/dist /usr/share/nginx/html
RUN chmod +x /iniciar-nginx.sh
EXPOSE 80
CMD ["/iniciar-nginx.sh"]
