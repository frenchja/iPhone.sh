#!/usr/bin/env bash
#
# You must have ffmpeg installed with --enable-libfdk_aac.
#
# Author:  Jason A. French
#

ff=${type -P ffmpeg}
movies=( "$@" )

if [ "$#" -eq 0 ]; then
	echo "This script resamples and remuxes a series of movies for the iPhone 5."
	echo ""
	echo "Usage:  iphone.sh movie1.mkv movie2.mkv ..."
fi

function ffaudio {
	$ff -i $1 \
		-cutoff 19000 \
		-c:v copy \
		-c:a libfdk_aac \
		-profile:a aac_he_v2 \
		-b:a 48k \
		-ac 2 \
		$1.m4v
}

for arg; do
	ffaudio
done