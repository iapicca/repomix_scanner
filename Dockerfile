# Start from the official Repomix image
FROM ghcr.io/yamadashy/repomix:latest

# Set the working directory (this is where we will mount the volume)
WORKDIR /app

# Default environment variables
ENV REPO_URL="https://github.com/dart-lang/sdk"
ENV BRANCH="main"

# Cap Node.js memory to 1.5GB to prevent the Podman VM from silently crashing
ENV NODE_OPTIONS="--max-old-space-size=1536"

# Aggressive ignore list to filter out massive, non-architectural folders
ENV IGNORE_PATTERNS="**/*.test.*,**/*.spec.*,docs/,tests/,.github/,third_party/,pkg/,benchmarks/"

# Create the distillation script
RUN echo '#!/bin/sh\n\
set -e\n\
\n\
# Extract the repository name to use for the output filename\n\
REPO_NAME=$(basename -s .git "$REPO_URL")\n\
OUTPUT_FILE="/app/${REPO_NAME}_agent.md"\n\
\n\
echo "🚀 Starting distillation of $REPO_URL (Branch: $BRANCH)..."\n\
echo "🧠 Node Memory Limit: $NODE_OPTIONS"\n\
echo "🚫 Ignoring: $IGNORE_PATTERNS"\n\
\n\
# Run repomix natively against the remote URL with M1-safe flags\n\
repomix --remote "$REPO_URL" \\\n\
        --remote-branch "$BRANCH" \\\n\
        --style markdown \\\n\
        --output "$OUTPUT_FILE" \\\n\
        --compress \\\n\
        --remove-comments \\\n\
        --remove-empty-lines \\\n\
        --ignore "$IGNORE_PATTERNS"\n\
\n\
echo "======================================================="\n\
echo "✅ Distillation complete!"\n\
echo "📄 Slim agent file generated at: $OUTPUT_FILE"\n\
echo "======================================================="\n\
' > /usr/local/bin/distill.sh

# Make the script executable
RUN chmod +x /usr/local/bin/distill.sh

# Override the base image's entrypoint with our custom script
ENTRYPOINT ["/usr/local/bin/distill.sh"]