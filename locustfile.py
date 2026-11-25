from locust import HttpUser, task, between

class LLMUser(HttpUser):
    wait_time = between(1, 3)
    
    @task(3)
    def chat_completion(self):
        self.client.post("/v1/chat/completions", json={
            "model": "llama2-70b-dpo",
            "messages": [{"role": "user", "content": "Explain DPO vs PPO"}],
            "max_tokens": 256
        }, headers={"Authorization": "Bearer sk-ml-team-12345"})
    
    @task(1)
    def benchmark(self):
        self.client.post("/v1/benchmark", json={
            "prompt": "Generate 1M context summary",
            "max_tokens": 1024
        })
