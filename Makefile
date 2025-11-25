# Makefile for Retrieval Head Detection Documentation
# Generates HTML documentation from Python docstrings using pdoc

# Configuration
PYTHON := python3
PDOC := pdoc
DOC_DIR := docs
SOURCE_FILES := retrieval_head_detection.py needle_in_haystack_with_mask.py
MODULE_DIR := faiss_attn/source

# Default target
.PHONY: all
all: docs

# Install all dependencies
.PHONY: install
install:
	$(PYTHON) -m pip install -r requirements.txt

# Install documentation dependencies only
.PHONY: install-deps
install-deps:
	$(PYTHON) -m pip install pdoc3

# Generate documentation for main modules
.PHONY: docs
docs: install-deps clean
	@echo "Generating documentation..."
	mkdir -p $(DOC_DIR)
	$(PDOC) --html --output-dir $(DOC_DIR) --force $(SOURCE_FILES)
	@echo "Documentation generated in $(DOC_DIR)/"

# Generate documentation for custom modeling files
.PHONY: docs-modeling
docs-modeling: install-deps
	@echo "Generating documentation for custom modeling files..."
	mkdir -p $(DOC_DIR)/modeling
	$(PDOC) --html --output-dir $(DOC_DIR)/modeling --force $(MODULE_DIR)/modeling_llama.py
	$(PDOC) --html --output-dir $(DOC_DIR)/modeling --force $(MODULE_DIR)/modeling_qwen2.py
	$(PDOC) --html --output-dir $(DOC_DIR)/modeling --force $(MODULE_DIR)/modeling_mistral.py
	@echo "Modeling documentation generated in $(DOC_DIR)/modeling/"

# Generate complete documentation
.PHONY: docs-full
docs-full: docs docs-modeling
	@echo "Complete documentation generated!"

# Clean documentation directory
.PHONY: clean
clean:
	@echo "Cleaning documentation directory..."
	rm -rf $(DOC_DIR)

# Serve documentation locally
.PHONY: serve
serve: docs
	@echo "Starting local documentation server..."
	@echo "Open http://localhost:8000 in your browser"
	cd $(DOC_DIR) && $(PYTHON) -m http.server 8000

# Quick documentation preview (single file)
.PHONY: preview
preview:
	$(PDOC) --http localhost:8080 retrieval_head_detection.py

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all          - Generate main documentation (default)"
	@echo "  install      - Install all dependencies from requirements.txt"
	@echo "  docs         - Generate documentation for main modules"
	@echo "  docs-modeling- Generate documentation for custom modeling files"
	@echo "  docs-full    - Generate complete documentation"
	@echo "  install-deps - Install pdoc3 dependency only"
	@echo "  clean        - Remove generated documentation"
	@echo "  serve        - Serve documentation on localhost:8000"
	@echo "  preview      - Live preview on localhost:8080"
	@echo "  help         - Show this help message"

# Check if source files exist
.PHONY: check
check:
	@echo "Checking source files..."
	@for file in $(SOURCE_FILES); do \
		if [ -f $$file ]; then \
			echo "✓ $$file exists"; \
		else \
			echo "✗ $$file missing"; \
		fi; \
	done