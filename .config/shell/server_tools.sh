#!/usr/bin/env sh

function relax_restrictions() {
    cp /etc/nginx/nginx.conf /tmp/nginx-temp.conf

    sudo echo "worker_processes 1;

    events {
        worker_connections 256;
    }

    http {
        server {
            listen 80 default_server;
            server_name _;

            include error;

            location / {
                proxy_pass http://127.0.0.1:7272;

                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forward-For \$proxy_add_x_forwarded_for;
            }
        }
    }" > /etc/nginx/nginx.conf

    sudo ufw allow 80
    sudo ufw allow 443

    sudo ufw reload
    sudo nginx -s reload
}

function impose_restrictions() {
    sudo mv /tmp/nginx-temp.conf /etc/nginx/nginx.conf

    sudo ufw delete allow 80
    sudo ufw delete allow 443

    sudo ufw reload
    sudo nginx -s reload
}

function renew_certs() {
    relax_restrictions;
    sleep 5;
    sudo certbot renew --force-renewal --elliptic-curve=secp384r1;
    impose_restrictions;
}

