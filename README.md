iPhone.sh
=========

Personal BASH Script to remux and resample movies for the iPhone.

Prerequisites
-------------

You must have ffmpeg installed with --enable-libfdk_aac.

Using [MacPorts](https://www.macports.org/):

1.  Download and compile [libfdk](http://sourceforge.net/projects/opencore-amr/files/fdk-aac/) using `./configure && make && sudo make install`.
2.  Open `/opt/local/var/macports/sources/rsync.macports.org/release/tarballs/ports/multimedia/ffmpeg-devel/Portfile`
3.  Add `--enable-libfdk_aac` after `--enable-libfaac \` on line 214 and save.
4.  In Terminal:  `sudo port install ffmpeg-devel +nonfree +gpl3`

Installation
------------

1.  Download [iphone.sh](https://raw.github.com/frenchja/iPhone.sh/master/iphone.sh).
2.  Move to `/usr/bin/iphone.sh`.
3.  Mark as executable:  `sudo chmod +x /usr/bin/iphone.sh`


Usage
-----

`iphone.sh movie1.mkv movie2.mov`
