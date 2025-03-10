#!/bin/bash

set -euo pipefail

project_name="${PWD##*/}"

port="${1:-8888}"

docker run -p "${port}:8888" -v./:/work/ -td $project_name
