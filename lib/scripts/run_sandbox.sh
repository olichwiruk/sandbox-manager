#!/bin/bash

mkdir -p %{SANDBOX_DIR}/%{TOKEN}/data_vault/storage
mkdir -p %{SANDBOX_DIR}/%{TOKEN}/data_vault/mongodb_data

cp %{TEMPLATES_DIR}/docker-compose.yml %{SANDBOX_DIR}/%{TOKEN}/docker-compose.yml
sed -i 's|${TOKEN}|%{TOKEN}|g' %{SANDBOX_DIR}/%{TOKEN}/docker-compose.yml
sed -i 's|${SANDBOX_DIR}|%{SANDBOX_DIR}|g' %{SANDBOX_DIR}/%{TOKEN}/docker-compose.yml

docker-compose -f %{SANDBOX_DIR}/%{TOKEN}/docker-compose.yml up -d
