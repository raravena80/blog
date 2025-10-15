# Rico's Blog

Personal technology blog focused on DevOps, cloud-native technologies, containers, and Kubernetes.

## 🚀 Quick Start

### Prerequisites
- [Hugo Extended](https://gohugo.io/installation/) v0.139.0 or later (Beautiful Hugo requires v0.124+). See `COMPATIBILITY_NOTE.md` if you must build with an older version.
- Git

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/raravena80/blog.git
   cd blog
   ```

2. **Initialize theme submodule** (if using git submodules)
   ```bash
   git submodule update --init --recursive
   ```

3. **Start the development server**
   ```bash
   hugo server -D
   ```

4. **View the site**
   Open your browser to http://localhost:1313

### Building for Production

```bash
hugo --minify
```

The static site will be generated in the `docs/` directory (configured for GitHub Pages).

## 📁 Project Structure

```
.
├── config.toml           # Hugo configuration
├── content/
│   ├── post/            # Blog posts
│   └── page/            # Static pages (About, Speaking)
├── layouts/             # Custom layout overrides
├── static/              # Static assets (CSS, images)
├── themes/              # Beautiful Hugo theme
└── docs/                # Generated site output (GitHub Pages)
```

## ✍️ Creating New Content

### New Blog Post

```bash
hugo new post/YYYY-MM-DD-post-title.md
```

Edit the generated file and ensure the front matter includes:
- `title`: Post title
- `date`: Publication date
- `tags`: Relevant tags
- `categories`: Post categories
- `description`: Brief summary for SEO

### New Page

```bash
hugo new page/page-name.md
```

## 🎨 Customization

- **Custom CSS**: Edit `static/css/custom.css`
- **Configuration**: Modify `config.toml` for site settings
- **Layouts**: Override theme templates in the `layouts/` directory

## 🚢 Deployment

### Automated Deployment (Recommended)

The repository includes a GitHub Actions workflow that automatically builds and deploys your site:

1. **Make content changes** in your branch
2. **Commit and push** to `main` or `master` branch
3. **GitHub Actions automatically**:
   - Builds the site with Hugo v0.139.0
   - Deploys to the `gh-pages` branch
   - GitHub Pages serves from the `gh-pages` branch

**First-time setup:**
- Go to repository Settings → Pages
- Set Source to "Deploy from a branch"
- Select `gh-pages` branch and `/ (root)` folder
- Save and wait for deployment

### Manual Deployment (Alternative)

If you prefer manual control:

```bash
hugo --minify
# Manually commit and push the docs/ directory (force-add because docs/ is gitignored)
git add -f docs/
git commit -m "Rebuild site"
git push
```

Configure GitHub Pages to serve from the `main` branch `/docs` directory.

## 📦 Theme

This blog uses the [Beautiful Hugo](https://github.com/halogenica/beautifulhugo) theme.

To update the theme:
```bash
cd themes/beautifulhugo
git pull origin master
```

## 🔧 Development Commands

Common commands for working with the blog:

```bash
# Start development server
hugo server -D

# Start server with drafts and future posts
hugo server -D -F

# Build for production
hugo --minify

# Check Hugo version
hugo version

# Clean build cache
hugo mod clean
```

### Makefile shortcuts

```bash
make help         # Show available targets
make serve        # Start Hugo server with drafts
make serve-all    # Start server with drafts and future posts
make build        # Build the site into docs/
make deploy       # Build and prepare for manual deployment
make new-post TITLE=my-new-post
make new-page NAME=about
```

## 🧩 Shortcodes

Custom Hugo shortcodes available in `layouts/shortcodes/`:

- `{{< callout type="tip" title="Pro tip" >}}Content{{< /callout >}}`
- `{{< youtube VIDEO_ID title="Optional title" >}}`

These shortcodes add styled callouts and privacy-friendly YouTube embeds with responsive sizing.

## 🔍 SEO

- `static/robots.txt` controls crawler access and references the sitemap
- Archetype templates include `description`, `keywords`, and `slug` fields for better metadata
- Be sure to update `config.toml` with accurate social links and descriptions

## 📄 License

- **Content**: Posts and pages are © Ricardo Aravena. All rights reserved.
- **Code**: Site source code is available under the MIT License.

## 👤 Author

**Ricardo Aravena**
- Website: https://serverbooter.com
- GitHub: [@raravena80](https://github.com/raravena80)
- Twitter: [@raravena80](https://twitter.com/raravena80)
- LinkedIn: [raravena](https://linkedin.com/in/raravena)

## 🤝 Contributing

Found a typo or issue? Feel free to open an issue or submit a pull request!

1. Fork the repository
2. Create your feature branch (`git checkout -b fix/typo`)
3. Commit your changes (`git commit -am 'Fix typo in post'`)
4. Push to the branch (`git push origin fix/typo`)
5. Open a Pull Request
