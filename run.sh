#!/bin/bash

set -euo pipefail

project_name="${PWD##*/}"

docker run -p 8888:8888 -v./:/work/ -td $project_name
