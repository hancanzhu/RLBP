# RLBP
This is the implement for "Multi-atlas label fusion with random local binary pattern features: Application to hippocampus segmentation, submitted to Scientific Report."

In the direction "data", there is the image dataset for hippocampus segmentation. The "Left" folder is for the left hippocampus, while the "right" folder is for the right hippocampus. In the direction "Left/Right", there are three folders "target", "storeRegistration" and "result". The "Target" folder contains one image to be segmented. The direction "storeRegistration" contains the warped atlases for the target image. The segmentation results will be put in the "result" folder. 

In the direction "RLBP_label_fusion", there are several matlab functions for the proposed RLBP based hippocampus segmentation. "segmentationInterface.m" is the main function, which can directly run with MATLAB.

In the direction "tools", there is a third-party software "niiReader" for image IO.
