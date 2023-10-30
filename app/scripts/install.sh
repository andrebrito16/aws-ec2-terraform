#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt install -y git unzip nginx

# Install Bun
curl -fsSL https://bun.sh/install | bash
source /root/.bashrc

# Clone and set up the application
cd /home/ubuntu
git clone https://github.com/andrebrito16/ab-svc-hono-bun.git
cd ab-svc-hono-bun
bun install

# Run the application
nohup bun src/index.ts > app.log 2>&1 &

# Configure Nginx to forward port 80 to 3000
NGINX_CONF='/etc/nginx/sites-available/default'
sudo cp $NGINX_CONF "${NGINX_CONF}.bak" # Backup the original config

# Write a new Nginx server block configuration
sudo bash -c "cat > $NGINX_CONF" << 'EOT'
server {
    listen 80;
    listen [::]:80;

    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOT

sudo service nginx restart
