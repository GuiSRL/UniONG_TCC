#!/bin/sh
# Descobre os servidores DNS do container (Docker: 127.0.0.11; Railway: IPv6 da rede interna)
# para o "resolver" do nginx e segue para o entrypoint oficial, que aplica o modelo de configuração.
set -e
NGINX_LOCAL_RESOLVERS=$(awk 'BEGIN { ORS = " " } $1 == "nameserver" { if ($2 ~ ":") print "[" $2 "]"; else print $2 }' /etc/resolv.conf)
[ -n "$NGINX_LOCAL_RESOLVERS" ] || NGINX_LOCAL_RESOLVERS=127.0.0.11
export NGINX_LOCAL_RESOLVERS
# BACKEND_URL não pode terminar com barra (o nginx repassaria o caminho errado).
BACKEND_URL=${BACKEND_URL%/}
export BACKEND_URL
echo "nginx: porta ${PORT}, backend ${BACKEND_URL}, DNS ${NGINX_LOCAL_RESOLVERS}"
exec /docker-entrypoint.sh nginx -g 'daemon off;'
