#!/usr/sbin/bash

PROJECT="Project_Path"
DATA="${PROJECT}/<data_folder>"

conda activate condaenv

# ###########################################################################
# # run gather scripts
# ###########################################################################
python3 ${PROJECT}/gather_tile_loc.py || exit 1


cd ${DATA}

TIME=$(date +'%H_%M')

echo ${TIME}

git commit -am "${TIME}"
git push origin main



