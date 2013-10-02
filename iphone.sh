#!/usr/bin/env bash
#
# You must have ffmpeg installed with --enable-libfdk_aac.
#
# Author:  Jason A. French
#

ff=$(type -P ffmpeg)
movies=( "$@" )

NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

function red() {
    echo -e "$RED$*$NORMAL"
}

function green() {
    echo -e "$GREEN$*$NORMAL"
}

function yellow() {
    echo -e "$YELLOW$*$NORMAL"
}

if [ "$#" -eq 0 ]; then
	echo "This script resamples and remuxes a series of movies for the iPhone 5."
	echo ""
	echo "Usage:  iphone.sh movie1.mkv movie2.mkv ..."
fi

function fixport {
	match='--enable-libfaac'
	insert='--enable-libfdk_aac'
	port='/opt/local/var/macports/sources/rsync.macports.org/release/tarballs/ports/multimedia/ffmpeg-devel/Portfile'
	sudo sed -i "s/$match/$match\n$insert/" $port
}

function ffaudio {
	filename=$(basename "$i")
	# Cut .mkv extension
	filename="${filename%.*}"
	$ff -i $i \
		-cutoff 19000 \
		-c:v copy \
		-c:a libfdk_aac \
		-profile:a aac_he_v2 \
		-b:a 48k \
		-ac 2 \
		"$filename.m4v"
}

for i in "${movies[@]}"; do
	ffaudio
	return 0
done