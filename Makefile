.PHONY: help serve build clean deploy new-post

help: ## Show this help message
    @echo 'Usage: make [target]'
    @echo ''
    @echo 'Available targets:'
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

serve: ## Start Hugo development server
    hugo server -D

serve-all: ## Start Hugo server with drafts and future posts
    hugo server -D -F

build: ## Build the site for production
    hugo --minify

clean: ## Clean generated files
    rm -rf public/ resources/ .hugo_build.lock

deploy: build ## Build and prepare for deployment
    @echo "Site built successfully in docs/ directory"
    @echo "Push to main/master to trigger GitHub Actions deployment"

new-post: ## Create a new blog post (usage: make new-post TITLE=my-post-title)
    @if [ -z "$(TITLE)" ]; then \
        echo "Error: Please provide a TITLE parameter"; \
        echo "Usage: make new-post TITLE=my-post-title"; \
        exit 1; \
    fi
    hugo new post/$$(date +%Y-%m-%d)-$(TITLE).md

new-page: ## Create a new page (usage: make new-page NAME=page-name)
    @if [ -z "$(NAME)" ]; then \
        echo "Error: Please provide a NAME parameter"; \
        echo "Usage: make new-page NAME=page-name"; \
        exit 1; \
    fi
    hugo new page/$(NAME).md

version: ## Show Hugo version
    hugo version

check: ## Check for broken links (requires htmltest)
    @if command -v htmltest >/dev/null 2>&1; then \
        htmltest; \
    else \
        echo "htmltest not installed. Install from: https://github.com/wjdp/htmltest"; \
    fi
