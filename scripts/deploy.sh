#!/bin/bash
yum update
yum install -y nginx
yum install nodejs npm --enablerepo=epel

groupadd node-demo
useradd -d /app -s /bin/false -g node-demo node-demo

mv /app /app
chown -R node-demo:node-demo /app

echo 'user root;
worker_processes auto;
pid /run/nginx.pid;

events {
        worker_connections 768;
        # multi_accept on;
}

http {
  server {
    listen 80;
    location / {
      proxy_pass http://localhost:3000/;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  }
}' > /etc/nginx/nginx.conf

service nginx start

cd /app/app
npm install
