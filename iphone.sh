#!/usr/bin/env bash
#
# You must have ffmpeg installed with --enable-libfdk_aac.
#
# Author:  Jason A. French
#

ff=$(type -P ffmpeg)
movies=( "$@" )

if [ "$#" -eq 0 ]; then
	echo "This script resamples and remuxes a series of movies for the iPhone 5."
	echo ""
	echo "Usage:  iphone.sh movie1.mkv movie2.mkv ..."
fi

function ffaudio {
	$ff -i $i \
		-cutoff 19000 \
		-c:v copy \
		-c:a libfdk_aac \
		-profile:a aac_he_v2 \
		-b:a 48k \
		-ac 2 \
		$i.m4v
}

for i in "${movies[@]}"; do
	ffaudio
done