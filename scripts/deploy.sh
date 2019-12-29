#!/bin/bash
sudo yum update
sudo yum install -y nginx
sudo yum install nodejs npm --enablerepo=epel

sudo groupadd node-demo
sudo useradd -d /app -s /bin/false -g node-demo node-demo

mv /app /app
sudo chown -R node-demo:node-demo /app

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

sudo service nginx start

cd /app/app
sudo npm install
