# Repomix Scanner

## What is this?

This is a containerized, self-cleaning utility that extracts a highly compressed, AI-ready Markdown summary of any public GitHub repository. 

Powered by the official [Repomix](https://github.com/yamadashy/repomix) image, it intelligently strips out noise (like tests, docs, comments, and empty lines) and focuses on the core architecture. The resulting `.md` file is aggressively optimized to be dropped directly into your Google Antigravity `.agents/` folder without causing context dilution.

---

## Prerequisites: Podman (or Docker)

This tool runs in a container. You can use **Podman** (recommended) or **Docker**. 
*(Note: If you use Windows, you are on your own. These instructions are for Linux and macOS.)*

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

**Linux (Fedora/RHEL):**

```bash
sudo dnf install podman
```

*(If you prefer Docker, simply swap `podman` for `docker` in all the commands below. They are 100% interchangeable here.)*

---

## How to Run It

### 1. Build the Image

First, build the container image from the included `Dockerfile`:

```bash
podman build -t repo-distiller .
```

### 2. Distill a Repository

To run the extraction, you must mount your current directory (`$(pwd)`) to `/app` inside the container so the generated Markdown file is saved to your machine. 

**Run with default settings** (scans the `repomix` repo on `main`):

```bash
podman run --rm -v $(pwd):/app repo-distiller
```

**Run against a custom repository and branch:**
Pass your desired repository and branch as environment variables using the `-e` flag.

```bash
podman run --rm -v $(pwd):/app \
  -e REPO_URL="[https://github.com/expressjs/express](https://github.com/expressjs/express)" \
  -e BRANCH="master" \
  repo-distiller
```

### Output

Once the container finishes running, it will automatically delete itself (`--rm`) and leave behind a slim `<repo-name>_agent.md` file in your current directory, ready for your Antigravity agent.
