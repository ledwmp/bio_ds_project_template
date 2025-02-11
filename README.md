# Bio Data Science Project Template

A containerized data science environment for bioinformatics projects with commonly used tools and libraries.

## Features

- Jupyter Lab environment with Python 3.9
- Common bioinformatics tools (samtools, bedtools, bcftools, etc.)
- Popular data science libraries (pandas, scikit-learn, tensorflow, pytorch, etc.)
- Reproducible environment management using conda/mamba

## Prerequisites

- Docker
- Git

## Getting Started

1. Clone this repository and navigate to the project directory:
```bash
git clone https://github.com/ledwmp/bio_ds_project_template.git <project name>
cd <project name>
```
2. Build the Docker container:
```bash
./build.sh
```
3. Start the container/Jupyter lab:
```bash
./run.sh
```
## Project Structure 
```
├── Dockerfile 
├── environment.yml 
├── build.sh # Script to build Docker container
├── run.sh # Script to run Jupyter Lab
├── pyproject.toml 
├── notebooks/
├── docs/
├── results/
|   └── figures/
├── data/
|   ├── raw # Downloaded/copied data
|   └── process/ # Munged/processed data
└── src/ # Source code directory
    └── my_package/ # Main package directory
```
## Environment Management
- The project uses a conda environment defined in 'environment.yml'. Updates to the environment require one to rebuild the container.

## Development
- Place Python modules in 'src/my_package'. The project is set up as a Python package, making it easy to import code in notebooks.

## License
- Project is licensed under the MIT License. See the LICENSE file for more details.