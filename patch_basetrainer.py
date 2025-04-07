"""
This script patches the basetrainer.py file to skip LR scheduler creation in test mode
"""
import os
import fileinput
import sys

# Path to the file
file_path = './usdsgen/trainer/basetrainer.py'

# Check if file exists
if not os.path.exists(file_path):
    print(f"Error: {file_path} does not exist.")
    sys.exit(1)

# Text to search for and modify in make_optimizer function
search_text = "    def make_optimizer(self):"
make_optimizer_patch = """    def make_optimizer(self):
        # Skip optimizer and scheduler creation in test mode
        if hasattr(self.config, 'mode') and self.config.mode == 'test':
            self.logger.info("Test mode detected - using dummy optimizer and scheduler")
            from torch.optim.lr_scheduler import LambdaLR
            # Create a minimal optimizer just to satisfy the code
            import torch
            self.optimizer = torch.optim.SGD([{'params': self.model.parameters()}], lr=0.001)
            self.lr_scheduler = LambdaLR(self.optimizer, lambda x: 1.0)
            return
"""

# Flag to track if we found the text
found = False

# Perform the replacement
for line in fileinput.input(file_path, inplace=True):
    if search_text in line and not found:
        found = True
        print(line, end='')  # Print the original line
        print(make_optimizer_patch, end='')  # Add our patch
    else:
        print(line, end='')

if found:
    print(f"Successfully patched {file_path}")
else:
    print(f"Warning: Could not find '{search_text}' in {file_path}")
