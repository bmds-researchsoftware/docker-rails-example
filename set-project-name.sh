#!/bin/sh

if [ $# -eq 1 ]; then
    sed -i "s/myapp/$1/g" database.yml
    sed -i "s/myapp/$1/g" docker-compose.yml
    sed -i "s/myapp/$1/g" Dockerfile
    sed -i "s/myapp/$1/g" .env
else
    echo "Usage: $0 project_name"
fi


