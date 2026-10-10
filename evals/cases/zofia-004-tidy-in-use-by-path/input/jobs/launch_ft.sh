#!/bin/bash
# fine-tune launcher; jobs 7712 and 7713 were started from this script
cd /work/proj
python train.py \
  --data /work/proj-wt/exp3/data/train_shards \
  --config-template /work/proj-wt/exp3/configs/ft_base.yaml \
  --seed "$1"
