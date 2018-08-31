#!/bin/bash
set -x

json_out=`pwd`/errors.json
report_out=`pwd`/report
rm -rf $json_out
rm -rf $report_out

apt install -y yasm diffutils

mkdir -p ffmpeg-samples
./configure --samples=ffmpeg-samples --cc=kcc --ld=kcc --extra-cflags="-fissue-report=$json_out" 
make -j`nproc`
make fate-rsync
make check -j`nproc`

touch $json_out && rv-html-report $json_out -o $report_out
rv-upload-report $report_out
