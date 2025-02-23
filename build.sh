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
    rm -rf .git*
    git init
    git add --all
    git commit -m "Initial commit to ${project_name}"
fi

local_environment_yml="environment.yml"
remote_environment_yml="https://raw.githubusercontent.com/ledwmp/bio_ds_project_template/refs/heads/main/environment.yml"

temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT

if ! curl -f -s "$remote_environment_yml" -o "$temp_file"; then
    echo "Error, failed to download remote environment file."
fi

if diff -q "$local_environment_yml" "$temp_file" > "/dev/null"; then
    echo "Environment files match. Pulling latest docker image..."
    if ! docker pull ledwmp/bio_ds_project_template-docker:latest; then
        echo "Error, failed to pull docker image."
        exit 1
    fi
    docker tag ledwmp/bio_ds_project_template-docker:latest $project_name
else
    echo "Environment files differed. Reubild new docker image..."
    if ! docker build -t $project_name . ; then
        echo "Error, failed to build docker image."
        exit 1
    fi
fi
