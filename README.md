# Ultimate LLM Training & Inference Stack (V5)

> Enterprise-grade LLM stack: DPO / FSDP / DeepSpeed training, vLLM + FlashAttention-2 serving, Kubernetes / Terraform / ArgoCD deployment, with Prometheus + Grafana monitoring and chaos testing.

This is a **flat project**: every file lives in the repo root, with no sub-folders.

## Features

- **Training:** DPO, FSDP, DeepSpeed, Megatron-LM, QLoRA
- **Inference:** vLLM PagedAttention, TensorRT-LLM, FlashAttention-2, FlashDecoding
- **Scale:** Ring Attention (1M context), MoE (1T params), Constitutional AI, RLAIF
- **Ops:** Docker Compose, Ray Serve on K8s, Helm, ArgoCD GitOps, Terraform (multi-region), Kong gateway, Prometheus/Grafana, Litmus chaos tests, Locust load tests

## Architecture

```mermaid
flowchart LR
    A[Raw Data] --> B[Megatron-LM]
    B --> C[FSDP / DeepSpeed]
    C --> D[FlashAttention-2]
    D --> E[DPO / RLAIF Alignment]
    E --> F[vLLM Serving]
    F --> G[Kong API Gateway]
    G --> H[Production Users]
```

## Deployment pipeline

```mermaid
flowchart TD
    Dev[Git push] --> CI[CI/CD pipeline]
    CI --> Img[Container image]
    Img --> Argo[ArgoCD GitOps sync]
    Argo --> K8s[Kubernetes + Ray Serve]
    TF[Terraform multi-region] --> K8s
    K8s --> Mon[Prometheus + Grafana]
    K8s --> Chaos[Litmus chaos tests]
```

## 3D diagrams

### Training and alignment
| | |
|---|---|
| ![DPO vs PPO reward](3d_dpo_vs_ppo_reward.jpg) | ![DPO loss landscape](3d_dpo_loss_landscape_final.jpg) |
| ![Constitutional AI](3d_constitutional_ai.png) | ![RLAIF](3d_rlaif.png) |
| ![FSDP all-gather](3d_fsdp_allgather_pattern.jpg) | ![FSDP vs DDP scaling](3d_fsdp_vs_ddp_scaling.jpg) |

### Attention and scale
| | |
|---|---|
| ![FlashAttention-2 tiling](3d_flashattention2_block_tiling.jpg) | ![FlashAttn2 vs v1 bandwidth](3d_flashattn2_vs_v1_bandwidth.jpg) |
| ![Ring attention 1M](3d_ring_attention_1m_context.png) | ![Blockwise parallel](3d_blockwise_parallel_attention.png) |
| ![Striped attention](3d_striped_attention.png) | ![FlashDecoding](3d_flashdecoding.png) |
| ![MoE 1T](3d_moe_1t_params.png) | ![MegaBlocks MoE](3d_megablocks_moe.png) |

### Serving and operations
| | |
|---|---|
| ![Paged vLLM](3d_paged_vllm.png) | ![API gateway flow](3d_api_gateway_flow.png) |
| ![CI/CD pipeline](3d_cicd_pipeline.png) | ![ArgoCD GitOps](3d_argocd_gitops.png) |
| ![Multi-region](3d_multi_region.png) | ![Monitoring dashboard](3d_monitoring_dashboard.png) |
| ![Chaos engineering](3d_chaos_engineering.png) | |

### Advanced training and serving (new in V5)
| | |
|---|---|
| ![QLoRA 4-bit](3d_qlora_4bit.png) | ![DeepSpeed ZeRO stages](3d_deepspeed_zero_stages.png) |
| ![Megatron tensor + pipeline parallel](3d_megatron_tensor_pipeline_parallel.png) | ![GPU memory breakdown](3d_gpu_memory_breakdown.png) |
| ![Speculative decoding](3d_speculative_decoding.png) | ![Continuous batching + KV cache](3d_continuous_batching_kv_cache.png) |
| ![GQA vs MHA](3d_gqa_vs_mha.png) | ![Ray Serve autoscaling](3d_ray_serve_autoscaling.png) |

## Quick start

```bash
pip install -r requirements.txt
jupyter notebook Upgraded_Notebook_Complete.ipynb
```

Run the local stack (needs NVIDIA GPUs):

```bash
docker compose up -d
```

## Files

| File | Purpose |
|---|---|
| `Upgraded_Notebook_Complete.ipynb` | Main notebook |
| `benchmark_all.py` | Benchmark script |
| `test_llm_stack.py`, `locustfile.py` | Unit and load tests |
| `docker-compose.yml`, `kong.yml` | Local stack and API gateway |
| `k8s_ray_serve.yaml`, `helm_values.yaml`, `argocd_application.yaml` | Kubernetes / Helm / GitOps |
| `terraform_main.tf`, `terraform_multi_region_main.tf` | Infrastructure as code |
| `prometheus.yml`, `grafana_dashboard.json` | Monitoring |
| `litmus-experiments.yaml` | Chaos experiments |
| `ARCHITECTURE.md`, `mkdocs.yml` | Docs |
| `3d_*.png / 3d_*.jpg` | 29 3D diagrams |

## Benchmarks

| Model | Method | MT-Bench | Cost | Latency |
|---|---|---|---|---|
| LLaMA-2-70B | RLHF-PPO | 8.2 | $50K | 100ms |
| LLaMA-2-70B | DPO | 8.9 | $500 | 25ms |

> Figures are illustrative targets from the project design, not independently verified results. Replace them with your own measured numbers before publishing.

## Notes

- `argocd_application.yaml` uses a placeholder `repoURL` (`github.com/company/llm-stack`); change it to your own repo.
- GPU-heavy parts (vLLM, DeepSpeed, Megatron) need NVIDIA hardware.

## License

MIT (add a `LICENSE` file).
