#!/bin/bash

mkdir -p %{SANDBOX_DIR}/%{TOKEN}/data_vault/storage
mkdir -p %{SANDBOX_DIR}/%{TOKEN}/data_vault/mongodb_data

cp %{TEMPLATES_DIR}/docker-compose.yml %{SANDBOX_DIR}/%{TOKEN}/docker-compose.yml
sed -i 's|${TOKEN}|%{TOKEN}|g' %{SANDBOX_DIR}/%{TOKEN}/docker-compose.yml
sed -i 's|${SANDBOX_DIR}|%{SANDBOX_DIR}|g' %{SANDBOX_DIR}/%{TOKEN}/docker-compose.yml

docker-compose -f %{SANDBOX_DIR}/%{TOKEN}/docker-compose.yml up -d

cp %{TEMPLATES_DIR}/nginx.conf %{SANDBOX_DIR}/%{TOKEN}/nginx.conf
sed -i 's|${TOKEN}|%{TOKEN}|g' %{SANDBOX_DIR}/%{TOKEN}/nginx.conf

cp %{SANDBOX_DIR}/%{TOKEN}/nginx.conf %{NGINX_DIR}/nginx-%{TOKEN}.conf
docker exec -it nginx /bin/bash -c 'nginx -s reload'
