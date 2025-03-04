#!/bin/bash

set -euo pipefail

project_name="${PWD##*/}"
origin_url=$(git remote get-url origin 2>/dev/null || echo "")
template_repo_name=$(basename -s .git "$origin_url" 2>/dev/null || echo "")

if [[ -n "$origin_url" && \
      "$origin_url" == "https://github.com/ledwmp/bio_ds_project_template.git" && \
      "$project_name" != "$template_repo_name" ]]; then
    echo "Git origin matches: $origin_url, remove git artifacts."
    rm LICENSE
    [ -f .gitignore ] && cp .gitignore gitignore.tmp
    rm -rf .git*
    [ -f gitignore.tmp ] && mv gitignore.tmp .gitignore
    git init
    git add --all
    git commit -m "Initial commit to ${project_name}"
fi

local_environment_yml="environment.yml"
remote_environment_yml="https://raw.githubusercontent.com/ledwmp/bio_ds_project_template/refs/heads/main/environment.yml"
local_dockerfile="Dockerfile"
remote_dockerfile="https://raw.githubusercontent.com/ledwmp/bio_ds_project_template/refs/heads/main/Dockerfile"

temp_env_file=$(mktemp)
temp_dockerfile=$(mktemp)
trap 'rm -f "$temp_env_file" "$temp_dockerfile"' EXIT

if ! curl -f -s "$remote_environment_yml" -o "$temp_env_file"; then
    echo "Error, failed to download remote environment file."
fi

if ! curl -f -s "$remote_dockerfile" -o "$temp_dockerfile"; then
    echo "Error, failed to download remote Dockerfile."
fi

echo "Pulling latest docker image..."
if ! docker pull ledwmp/bio_ds_project_template-docker:latest; then
    echo "Error, failed to pull docker image."
    exit 1
fi

if diff -q "$local_environment_yml" "$temp_env_file" > "/dev/null" && \
   diff -q "$local_dockerfile" "$temp_dockerfile" > "/dev/null"; then
    echo "Environment files and Dockerfile match. Using latest docker image..."
    docker tag ledwmp/bio_ds_project_template-docker:latest $project_name
else
    echo "Environment files or Dockerfile differed. Building new docker image..."
    if ! docker build -t $project_name . ; then
        echo "Error, failed to build docker image."
        exit 1
    fi
fi
