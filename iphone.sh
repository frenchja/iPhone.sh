#!/usr/bin/env bash
#
# You must have ffmpeg installed with --enable-libfdk_aac.
#
# Author:  Jason A. French
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
#
# TODO 1) Add getopt() support.

ff=$(type -P ffmpeg)
probe=$(type -P ffprobe)
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
red() {
    echo -e "$RED${*}$NORMAL"
}
green() {
    echo -e "$GREEN${*}$NORMAL"
}
yellow() {
    echo -e "$YELLOW${*}$NORMAL"
}
# Echo usage
if [ "$#" -eq 0 ]; then
	echo "This script resamples and remuxes a series of movies for the iPhone 5."
	echo ""
	echo "Usage:  iphone.sh movie1.mkv movie2.mkv ..."
fi

checkFFMPEG() {
	# Check for libfdk-aac
	ffmpegOutput=$($ff -encoders | grep libfdk_aac)
	if [[ "$ffmpegOutput" != *"Fraunhofer FDK AAC (codec aac)"* ]]; then
		red "Exiting!  ffmpeg not compiled with libfdk_aac!"
		exit 1
	fi
}
fixport() {
	if [[ type port >/dev/null 2>&1 ]]; then
		match='--enable-libfaac'
		insert='--enable-libfaac --enable-libfdk_aac'
		port='/opt/local/var/macports/sources/rsync.macports.org/release/tarballs/ports/multimedia/ffmpeg-devel/Portfile'
		sudo sed -i "s/$match/$insert/" $port
	else
		red "Macports not found.  Please install ffmpeg with libfdk-aac manually."
		exit 1
	fi
}
iphone() {
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
ps3() {
	# PS3 muxer
	filename=$(basename "$i")
	# Cut .mkv extension
	filename="${filename%.*}"
	if ffprobe -of flat ${i} 2>&1 | grep 'Audio: aac'; then
		AUDIO="-c:a copy \\"
		green "Copying aac audio codec."
	else
		AUDIO="-c:a libfdk_aac -vbr 3 -ac 2 \\"
		yellow "Transcoding audio to aac."
	fi
	$ff -i $i \
		-cutoff 19000 \
		-c:v copy \
		${AUDIO}
		"$filename.mp4"
}

if [ "$@" == *"--install-ffmpeg"* ]; then
	echo "Installing ffmpeg with libfdk_aac"
	fixport
else
	movies=( "$@" )
	checkFFMPEG
	for i in "${movies[@]}"; do
		iphone
	done
fi