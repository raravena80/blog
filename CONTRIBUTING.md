# Contributing to Rico's Blog

Thank you for your interest in contributing! Contributions of all kinds are welcome.

## Ways to Contribute

### 🐛 Report Issues

Found a typo, broken link, or technical issue? Please [open an issue](https://github.com/raravena80/blog/issues) with:

- A clear, descriptive title
- Steps to reproduce the issue (if applicable)
- What you expected to happen vs. what actually happened
- Screenshots if relevant

### ✏️ Fix Typos or Errors

Small fixes are always welcome! For typos or minor corrections:

1. Fork the repository
2. Create a branch: `git checkout -b fix/typo-in-post-title`
3. Make your changes
4. Commit: `git commit -m 'Fix typo in post about containers'`
5. Push and open a pull request

### 🔧 Technical Improvements

For larger technical changes:

1. Open an issue first to discuss the change
2. Wait for feedback before implementing
3. Follow the project's code style and conventions
4. Include a clear description in your pull request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/blog.git
cd blog

# Install Hugo (if not already installed)
# See: https://gohugo.io/installation/

# Start development server
make serve
# or: hugo server -D

# View at http://localhost:1313
```

## Code Style

### Front Matter

All posts should include:

```yaml
---
title: "Your Post Title"
date: 2025-10-15T10:00:00Z
draft: false
description: "Brief summary for SEO"
tags: ["kubernetes", "docker"]
categories: ["technology"]
keywords: kubernetes docker containers
---
```

### Writing Guidelines

- Use clear, concise language
- Include code examples in fenced code blocks with language tags
- Add alt text to all images
- Link to authoritative sources when referencing external content

### CSS

- Follow existing dark mode patterns using `[data-theme="dark"]`
- Test changes in both light and dark modes
- Keep specificity low to avoid conflicts with the theme

## Commit Messages

- Use present tense: "Fix typo" not "Fixed typo"
- Capitalize the first letter
- Keep the first line under 72 characters
- Reference issues when applicable: "Fix broken link (#123)"

## Testing

Before submitting a pull request:

```bash
# Build the site
make build

# Check for issues
hugo --cleanDestinationDir
```

## Content License

- **Posts/Pages**: All content is © Ricardo Aravena unless otherwise noted
- **Code**: Source code and examples are available under the MIT License

By contributing, you agree that your contributions will be licensed under the repository's existing license.

## Questions?

Feel free to open an issue with the "question" label if you need clarification on anything.

Thank you for contributing! 🎉
