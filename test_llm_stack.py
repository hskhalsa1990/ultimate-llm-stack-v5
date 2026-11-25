import pytest
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

def test_dpo_loss():
    """Test DPO loss calculation"""
    batch_size, seq_len = 4, 128
    logits = torch.randn(batch_size, seq_len, 32000)
    labels = torch.randint(0, 32000, (batch_size, seq_len))
    
    # DPO loss should be positive
    loss = dpo_loss(logits, labels, ref_logits)
    assert loss > 0
    assert not torch.isnan(loss)

def test_flash_attention():
    """Test FlashAttention-2 output shape"""
    q = torch.randn(2, 8, 1024, 64).cuda()
    k = torch.randn(2, 8, 1024, 64).cuda()
    v = torch.randn(2, 8, 1024, 64).cuda()
    
    out = flash_attn_func(q, k, v, causal=True)
    assert out.shape == q.shape

def test_fsdp_sharding():
    """Test FSDP parameter sharding"""
    model = AutoModelForCausalLM.from_pretrained("gpt2")
    fsdp_model = FSDP(model)
    
    # Check shards are distributed
    for param in fsdp_model.parameters():
        assert param._is_sharded

def test_vllm_paged():
    """Test vLLM paged attention"""
    from vllm import LLM
    llm = LLM(model="facebook/opt-125m", block_size=16)
    outputs = llm.generate(["Hello world"])
    assert len(outputs) == 1
