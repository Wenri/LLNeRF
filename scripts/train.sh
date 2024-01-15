#!/bin/bash

# *** Please replace /path/to/dataset with your dataset path
DATA_DIR_PREFIX="/home/wenri/pCloudDrive/ResearchProjects/REMAP/nerf_yuehao/"
CHECKPOINT_PREFIX="/home/wenri/pCloudDrive/ResearchProjects/REMAP/nerf_results/llnerf/llnerf__"
LOG_PREFIX="logs/llnerf__"

function train() {
  SCENE_NAME="$1"

  # stage 1: decompositoin only, without enhancement.
  python -m train \
    --gin_configs=configs/llff_illunerf.gin \
    --gin_bindings="Config.data_dir = '${DATA_DIR_PREFIX}${SCENE_NAME}'" \
    --gin_bindings="Config.checkpoint_dir = '${CHECKPOINT_PREFIX}${SCENE_NAME}'" \
    --gin_bindings="Config.factor = 1" \
    --gin_bindings="Config.batch_size = 1024" \
    --gin_bindings="Config.checkpoint_every = 25000" \
    --gin_bindings="Config.valid_steps = []" \
    --gin_bindings="Config.max_steps = 100000" \
    --gin_bindings="Config.rawnerf_mode = False" \
    --gin_bindings="Model.learned_exposure_scaling = False" \
    --gin_bindings="Model.name = 'llnerf'" \
    --gin_bindings="Config.logfile = '${LOG_PREFIX}${SCENE_NAME}.txt'" \
    --logtostderr \
    --gin_bindings="Config.data_loss_type = 'rawnerf'" \
    --gin_bindings="NerfMLP.learn_gamma = True" \
    --gin_bindings="NerfMLP.learned_gamma_nc = 3" \
    --gin_bindings="NerfMLP.learn_alpha = True" \
    --gin_bindings="NerfMLP.learned_alpha_nc = 1" \
    --gin_bindings="Config.exposure_loss_mult = 0.1" \
    --gin_bindings="Config.gamma_norm_loss_mult = 0.01" \
    --gin_bindings="Config.sample_neighbor_num = 4" \
    --gin_bindings="Config.alpha_ltv_loss_mult = 0.1" \
    --gin_bindings="Config.gamma_ltv_loss_mult = 0.1" \
    --gin_bindings="Config.gray_variance_bias = 0.5" \
    --gin_bindings="Config.gray_loss_mult = 0.1" \
    --gin_bindings="Config.fixed_exposure = 0.55" \
    --gin_bindings="Config.disable_enhancement_loss = True"
}

function refine() {
  SCENE_NAME="$1"

  # stage 2: enhancement
  python -m train \
    --gin_configs=configs/llff_illunerf.gin \
    --gin_bindings="Config.data_dir = '${DATA_DIR_PREFIX}${SCENE_NAME}'" \
    --gin_bindings="Config.checkpoint_dir = '${CHECKPOINT_PREFIX}${SCENE_NAME}'" \
    --gin_bindings="Config.factor = 1" \
    --gin_bindings="Config.batch_size = 1024" \
    --gin_bindings="Config.checkpoint_every = 25000" \
    --gin_bindings="Config.valid_steps = [5000, 25000]" \
    --gin_bindings="Config.max_steps = 100000" \
    --gin_bindings="Config.rawnerf_mode = False" \
    --gin_bindings="Model.learned_exposure_scaling = False" \
    --gin_bindings="Model.name = 'llnerf'" \
    --gin_bindings="Config.logfile = '${LOG_PREFIX}${SCENE_NAME}.txt'" \
    --logtostderr \
    --gin_bindings="Config.data_loss_type = 'rawnerf'" \
    --gin_bindings="NerfMLP.learn_gamma = True" \
    --gin_bindings="NerfMLP.learned_gamma_nc = 3" \
    --gin_bindings="NerfMLP.learn_alpha = True" \
    --gin_bindings="NerfMLP.learned_alpha_nc = 1" \
    --gin_bindings="Config.exposure_loss_mult = 0.1" \
    --gin_bindings="Config.gamma_norm_loss_mult = 0.01" \
    --gin_bindings="Config.sample_neighbor_num = 4" \
    --gin_bindings="Config.alpha_ltv_loss_mult = 0.1" \
    --gin_bindings="Config.gamma_ltv_loss_mult = 0.1" \
    --gin_bindings="Config.gray_variance_bias = 0.5" \
    --gin_bindings="Config.gray_loss_mult = 0.1" \
    --gin_bindings="Config.fixed_exposure = 0.55" \
    --gin_bindings="Config.max_steps = 105000"
}

# and replace scene_name with your scene name.
#train pavilion && refine pavilion
#train strat2 && refine strat2
train sysstatue && refine sysstatue
train xuesihall && refine xuesihall
train flowercart && refine flowercart