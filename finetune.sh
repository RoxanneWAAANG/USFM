#!/bin/bash
# finetune.sh - Fine-tune USFM on a downstream segmentation task

# Set environment variables
export batch_size=16
export num_workers=4
export CUDA_VISIBLE_DEVICES=0,1,2
export devices=3           # Number of GPUs
export dataset=toy_dataset
export epochs=400
export pretrained_path=./assets/FMweight/USFM_latest.pth
export task=Seg           # Use 'Cls' for classification task
export model=Seg/SegVit     # For segmentation, you can choose between 'SegVit' or 'Upernet'

# Run the fine-tuning command
python main.py experiment=task/$task \
    data=Seg/$dataset \
    data="{batch_size:$batch_size,num_workers:$num_workers}" \
    model=$model \
    model.model_cfg.backbone.pretrained=$pretrained_path \
    train="{epochs:$epochs, accumulation_steps:1}" \
    L="{devices:$devices}" \
    tag=USFM
