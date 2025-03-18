#!/bin/bash

CONDA_PATH="${HOME}/miniforge3"
if [ -d "$CONDA_PATH" ]; then
  exit 0
fi

PREFIX=https://github.com/conda-forge/miniforge/releases/latest/download
PREFIX=https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease

wget -O Miniforge3.sh "${PREFIX}/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "${CONDA_PATH}"

source "${CONDA_PATH}/etc/profile.d/conda.sh"
conda env create -f ~/.local/share/chezmoi/.environment.yml

