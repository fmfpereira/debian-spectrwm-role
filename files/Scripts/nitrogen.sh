#!/bin/bash
#    ___      ___                 _         
#   / _/_ _  / _/__  ___ _______ (_)______ _
#  / _/  ' \/ _/ _ \/ -_) __/ -_) / __/ _ `/
# /_//_/_/_/_// .__/\__/_/  \__/_/_/  \_,_/ 
#            /_/         
# debian spectrwm nitrogen script.

# --- CONFIG VARIABLES DEFINITION

IMAGES_PATH=~/.config/nitrogen/backgrounds
UNSPLASH_URL=https://source.unsplash.com/random/1920x1080/?background,landscape,space,technology,retro
SLEEP_SEC=3600

# --- SCRIPT START

# CHECK IF PATH EXIST AND IS EMPTY
if [ ! -d "$IMAGES_PATH" ]; then
  mkdir -p $IMAGES_PATH
elif [ "$(ls -A $IMAGES_PATH)" ]; then
  rm -r "$IMAGES_PATH"/*
fi

# GET THE NUMBER OF DISPLAYS
NUMBER_DISPLAYS=$(xrandr -d :0 -q | grep " connected" | wc -l)

# LOOP
while :; do
  ## ITERATE OVER DISPLAYS
  for (( COUNT = 1; COUNT <= $NUMBER_DISPLAYS; COUNT++ )) 
  do
    # SET THE TARGET FILE NAME BASED ON THE DISPLAY COUNT
    TARGET_FILE=$IMAGES_PATH/screen_$COUNT
    # GET A RANDOM IMAGE
    curl -L --fail --silent --output $TARGET_FILE $UNSPLASH_URL && \
    # COMPUTE THE FILE EXTENSION
    EXTENSION=$(file --extension $TARGET_FILE | awk '{print $2}' | cut -d "/" -f 1) && \
    # ADD THE FILE EXTENSION
    mv $TARGET_FILE $TARGET_FILE.$EXTENSION && \
    # NITROGEN HEAD STARTS BY 0 AND LOOP COUNTER STARTS BY 1
    HEAD=$((COUNT - 1)) && \
    # SET NITROGEN BACKGROUND
    nitrogen --set-zoom-fill $TARGET_FILE.$EXTENSION --head=$HEAD
  done
	sleep $SLEEP_SEC
done