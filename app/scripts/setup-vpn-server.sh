#!/bin/sh

wait_for_dpkg() {
    while sudo lsof /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
        echo "Waiting for other software managers to finish..."
        sleep 2
    done
}

wait_for_dpkg
apt -y remove needrestart
wait_for_dpkg

# Crete instalation log file
touch /tmp/setup-vpn-server.log
touch /var/log/openvpn.log

# Update and install lzop and openvpn
wait_for_dpkg
apt-get update
wait_for_dpkg
apt-get install -y lzop openvpn

# Create and write to matriz.conf
bash -c 'cat > /etc/openvpn/matriz.conf << EOF
dev tun
ifconfig 10.0.0.1 10.0.0.2
secret /etc/openvpn/aula
port 5000
comp-lzo
log-append /var/log/openvpn.log
EOF'

# Create and write to aula secret key
bash -c 'cat > /etc/openvpn/aula << EOF
#
# 2048 bit OpenVPN static key
#
-----BEGIN OpenVPN Static key V1-----
011e89f9e0c69894da47b297e9951aa3
aa64632a7e2395bc69e899aec06418a4
6e166f39781596f9f874838aeb0067c6
6db5c5ee97f0b17e4d5410cf4e045837
60a7b62a2fb45acdb2b5f2cf42eceb01
1f33ad33e26df78f4247ca211eb8b0b3
c999d49d0037a2cc6a036cccc605d6c3
3207f05079d85f1fefaf8705c3923bc8
d875e648eefa477e8ef8bfe59193f135
f13547ac939508be7f0f3eeced601797
ad75c52f2a14c88a683900cc67970054
5f5b1d658c70aa32b9303f5fd4ec3b5b
3cd2c060f6805444fb035838ad12980d
2c630e04b1ab657fdd92fc9c8cf1e0fa
0954d753eef6f84444fa3c24843b7d88
469c8b2e89f860db6684b50dea170475
-----END OpenVPN Static key V1-----
EOF'

install_docker() {
    wait_for_dpkg
    apt install net-tools
    wait_for_dpkg
    sudo apt-get update
    wait_for_dpkg
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
    wait_for_dpkg
    sudo apt-get update
    wait_for_dpkg
    sudo apt-get install -y docker-ce
}

start_docker() {
    if [ -x "$(command -v docker)" ]; then
        echo "Docker already installed, checking status..."
        if ! systemctl is-active --quiet docker; then
            echo "Starting Docker..."
            sudo systemctl start docker
        else
            echo "Docker is already running."
        fi
        echo "Enabling Docker to start on boot..."
        sudo systemctl enable docker
    else
        echo "Docker not installed, installing..."
        install_docker
        echo "Starting Docker..."
        sudo systemctl start docker
        echo "Enabling Docker to start on boot..."
        sudo systemctl enable docker
    fi
}

pull_and_run() {
    sudo docker pull andrebrito16/go-nat:latest
    sudo docker run -d -p 5432:5432 andrebrito16/go-nat:latest
}

openvpn --config /etc/openvpn/matriz.conf --daemon

install_docker
start_docker

pull_and_run

