#!/bin/sh
# Inicia o gunicorn. Escuta em IPv6 ("[::]", que no Linux também aceita IPv4) quando o container tem
# IPv6 — exigido pela rede interna do Railway — e em 0.0.0.0 caso contrário. Porta: $PORT ou 8000.
set -e
PORTA=${PORT:-8000}
if python -c "import socket; s = socket.socket(socket.AF_INET6); s.bind(('::', 0))" 2>/dev/null; then
  ENDERECO="[::]:${PORTA}"
else
  ENDERECO="0.0.0.0:${PORTA}"
fi
echo "gunicorn: escutando em ${ENDERECO}"
exec gunicorn ong_backend.wsgi:application --bind "${ENDERECO}" \
  --workers "${GUNICORN_WORKERS:-3}" --timeout 60 --access-logfile -
