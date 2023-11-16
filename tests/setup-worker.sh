#!/bin/bash

sudo apt update && sudo apt install python3-pip -y

# Check if Locust is installed, if not install it
if ! command -v locust &> /dev/null
then
    echo "Locust could not be found, installing it now..."
    pip3 install locust
fi

# Create locustfile.py
cat <<EOF > locustfile.py
from locust import HttpUser, task, between

class QuickstartUser(HttpUser):
    wait_time = between(1, 5)

    @task
    def index_page(self):
        self.client.get("/")
EOF

# Run Locust worker in background using nohup
# Replace [master-hostname] and [master-port] with actual values
nohup locust -f locustfile.py --worker --master-host=3.218.117.28 &
