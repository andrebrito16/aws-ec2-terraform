from locust import HttpUser, task

class HelloWorldUser(HttpUser):
    @task
    def health_check(self):
        self.client.get("/")
        self.client.get("/health")