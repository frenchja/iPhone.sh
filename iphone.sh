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

ff=$(type -P ffmpeg)
movies=( "$@" )

NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

red() {
    echo -e "$RED$*$NORMAL"
}

green() {
    echo -e "$GREEN$*$NORMAL"
}

yellow() {
    echo -e "$YELLOW$*$NORMAL"
}

if [ "$#" -eq 0 ]; then
	echo "This script resamples and remuxes a series of movies for the iPhone 5."
	echo ""
	echo "Usage:  iphone.sh movie1.mkv movie2.mkv ..."
fi

checkFFMPEG() {
	ffmpegOutput=$($ff -encoders | grep libfdk_aac)
	if [[ "$ffmpegOutput" != "*Fraunhofer FDK AAC (codec aac)*" ]]; then
		red('Exiting!  ffmpeg not compiled with libfdk_aac!')
		exit 1
	fi
}

fixport() {
	match='--enable-libfaac'
	insert='--enable-libfdk_aac'
	port='/opt/local/var/macports/sources/rsync.macports.org/release/tarballs/ports/multimedia/ffmpeg-devel/Portfile'
	sudo sed -i "s/$match/$match\n$insert/" $port
}

ffaudio {
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