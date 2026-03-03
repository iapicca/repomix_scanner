# Repomix Scanner

## What is this?

This is a containerized, self-cleaning utility that extracts a highly compressed, AI-ready Markdown summary of any public GitHub repository.

Powered by the official [Repomix](https://github.com/yamadashy/repomix) image, it intelligently strips out noise. **This specific image is optimized for massive repositories and lower-RAM environments (like 8GB Macs)**. It caps Node.js memory usage and aggressively ignores large, non-architectural folders (like `third_party/` and `tests/`) to prevent Out of Memory (OOM) crashes during AST parsing.

---

## Prerequisites: Podman (or Docker)

This tool runs in a container. You can use **Podman** (recommended) or **Docker**.

### Installing Podman

**macOS (via Homebrew):**

```bash
brew install podman
podman machine init
podman machine start
```

**Linux (Ubuntu/Debian):**

```bash
sudo apt-get update
sudo apt-get install -y podman
```

*(If you prefer Docker, simply swap `podman` for `docker` in all the commands below.)*

---

## How to Run It

### 1. Build the Image

First, build the container image from the included `Dockerfile`. We will tag it as `repomix_scanner`:

```bash
podman build -t repomix_scanner .
```

### 2. Scan a Repository

To run the extraction, you must mount your current directory (`$(pwd)`) to `/app` inside the container so the generated Markdown file is saved to your machine.

**Run with default settings** (Currently set to scan `dart-lang/sdk` on `main` with aggressive memory/folder filtering):

```bash
podman run --rm -v $(pwd):/app repomix_scanner
```

### 3. Customizing the Run (Environment Variables)

You can override the defaults on the fly using the `-e` flag.

Available variables:

* `REPO_URL`: The GitHub URL to scan.
* `BRANCH`: The branch to scan (default: `main`).
* `NODE_OPTIONS`: Memory limit for Node (default: `--max-old-space-size=1536`).
* `IGNORE_PATTERNS`: Folders/files to skip.

**Example: Scanning a smaller repo (like Express.js) and keeping the tests:**
Because Express is small, we don't need the aggressive memory limits or the massive ignore list. We can overwrite them back to basic settings:

```bash
podman run --rm -v $(pwd):/app \
  -e REPO_URL="https://github.com/expressjs/express" \
  -e BRANCH="master" \
  repomix_scanner
```

### Output

Once the container finishes running, it will automatically delete itself (`--rm`) and leave behind a slim `<repo-name>_agent.md` file in your current directory, ready for your AI agent's context window.
