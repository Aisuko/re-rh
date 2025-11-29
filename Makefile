# Makefile for Retrieval Head Detection
# Run retrieval head detection with different parameter configurations
# Based on .vscode/launch.json configurations

# Configuration
PYTHON := python3
SCRIPT := retrieval_head_detection.py

# Model path from launch.json
MODEL_PATH ?= yaofu/llama-2-7b-80k

# Parameters from launch.json
START := 0
RTX4090_END := 5000
A100_END := 50000

# Default target
.PHONY: all
all: rtx4090

# Install dependencies
.PHONY: install
install:
	$(PYTHON) -m pip install -r requirements.txt

# RTX 4090 configuration (matches launch.json)
.PHONY: rtx4090
rtx4090:
	@echo "Running Retrieval Head Detection (RTX 4090 config)..."
	@echo "Model: $(MODEL_PATH), Range: $(START)-$(RTX4090_END)"
	$(PYTHON) $(SCRIPT) --model_path $(MODEL_PATH) --s $(START) --e $(RTX4090_END)

# A100 configuration (matches launch.json)
.PHONY: a100
a100:
	@echo "Running Retrieval Head Detection (A100 config)..."
	@echo "Model: $(MODEL_PATH), Range: $(START)-$(A100_END)"
	$(PYTHON) $(SCRIPT) --model_path $(MODEL_PATH) --s $(START) --e $(A100_END)

# Custom model path
.PHONY: custom
custom:
	@echo "Running with custom parameters..."
	@echo "Usage: make custom MODEL_PATH=your/model START=0 END=5000"
	$(PYTHON) $(SCRIPT) --model_path $(MODEL_PATH) --s $(START) --e $(END)

# Quick test (small range)
.PHONY: test
test:
	@echo "Running quick test (0-1000 tokens)..."
	$(PYTHON) $(SCRIPT) --model_path $(MODEL_PATH) --s 0 --e 1000

# Create necessary directories
.PHONY: setup
setup:
	@echo "Creating necessary directories..."
	mkdir -p head_score
	mkdir -p results/graph
	mkdir -p contexts

# Clean results
.PHONY: clean
clean:
	@echo "Cleaning results..."
	rm -rf results/graph/*
	rm -rf contexts/*

# Help target
.PHONY: help
help:
	@echo "Available targets (based on .vscode/launch.json):"
	@echo "  rtx4090  - RTX 4090 config (0-5K tokens) [default]"
	@echo "  a100     - A100 config (0-50K tokens)"
	@echo "  custom   - Custom parameters (set MODEL_PATH, START, END)"
	@echo "  test     - Quick test (0-1K tokens)"
	@echo "  install  - Install dependencies"
	@echo "  setup    - Create necessary directories"
	@echo "  clean    - Clean result files"
	@echo "  help     - Show this help"
	@echo ""
	@echo "Examples:"
	@echo "  make rtx4090"
	@echo "  make a100"
	@echo "  make custom MODEL_PATH=microsoft/DialoGPT-medium START=0 END=10000"
	@echo "  make test MODEL_PATH=gpt2"