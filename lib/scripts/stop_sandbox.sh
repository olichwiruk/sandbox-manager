#!/bin/bash

docker-compose -f %{SANDBOX_DIR}/%{TOKEN}/docker-compose.yml stop
rm %{NGINX_DIR}/nginx-%{TOKEN}.conf

docker exec -t nginx /bin/bash -c 'nginx -s reload'
