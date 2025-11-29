#!/usr/bin/env python3
import json
import numpy as np

# Load head score file for llama-2-7b-80k
with open('./head_score/llama-2-7b-80k.json') as file:
    head_list = json.loads(file.readline())

# Calculate average retrieval score and ranking
head_score_list = [([int(ll) for ll in l[0].split("-")], np.mean(l[1])) for l in head_list.items()]
head_score_list = sorted(head_score_list, key=lambda x: x[1], reverse=True) 

# Get top 10 retrieval heads
top_retrieval_heads = [[l[0], round(l[1], 2)] for l in head_score_list[:10]]

print("Top 10 Retrieval Heads for llama-2-7b-80k:")
print("=" * 50)
for i, (head, score) in enumerate(top_retrieval_heads, 1):
    layer, head_idx = head
    print(f"{i:2d}. Layer {layer:2d}, Head {head_idx:2d} - Score: {score:.2f}")

print(f"\nTotal heads analyzed: {len(head_score_list)}")
print(f"Highest retrieval score: {head_score_list[0][1]:.3f}")
print(f"Lowest retrieval score: {head_score_list[-1][1]:.3f}")