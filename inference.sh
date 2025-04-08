#!/bin/bash
# inference.sh - Run inference using USFM on a downstream segmentation task

# Set environment variables
export batch_size=2
export num_workers=4
export CUDA_VISIBLE_DEVICES=0,1,2
export dataset=toy_dataset                    # breast_us 
export pretrained_path=./assets/FMweight/USFM_latest.pth
export task=Seg           # Use 'Cls' for classification inference
export model=Seg/SegVit     # For segmentation; alternatively use 'Upernet' or 'vit' for classification

# Run the inference command with mode=test
python main.py mode=test experiment=task/$task \
    data=Seg/$dataset \
    data="{batch_size:$batch_size,num_workers:$num_workers}" \
    model=$model \
    model.model_cfg.backbone.pretrained=$pretrained_path \
    tag=USFM
    # +inference=True
