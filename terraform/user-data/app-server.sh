#!/bin/bash
set -e

# Update System Packages
sudo dnf update -y

# Install Nginx & Docker
sudo dnf install -y nginx docker

# Start and Enable Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Start and Enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Create Sample Web Page with Hostname for ALB Testing
HOSTNAME=$(hostname)
sudo cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>n-Tier App Server</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; background-color: #f4f4f9; }
        .card { background: white; padding: 20px; margin: auto; width: 50%; box-shadow: 0 4px 8px rgba(0,0,0,0.1); border-radius: 8px; }
        h1 { color: #2c3e50; }
        p { color: #7f8c8d; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Application Deployed Successfully! 🚀</h1>
        <p>Managed by Terraform | Deployed via CI/CD</p>
        <hr>
        <p><b>Served by Host:</b> ${HOSTNAME}</p>
    </div>
</body>
</html>
EOF

# Restart Nginx to apply changes
sudo systemctl restart nginx