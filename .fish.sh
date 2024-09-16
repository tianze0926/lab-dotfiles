#!/bin/bash

paths=(
  ~/miniforge3/envs/utils/bin/fish
  ~/miniconda3/envs/utils/bin/fish
  /usr/bin/fish
)

for path in "${paths[@]}"; do
  if [[ -x "$path" ]]; then
    exec "$path"
  fi
done

exec /bin/bash
