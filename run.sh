#!/bin/bash
      #  -p 6407:6407/udp \
echo 'Disabling X11 access control...'
xhost +
echo 'Launching container...'
docker run -ti --rm \
		-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
		-v /proc:/writable-proc \
		-v /ldisk/centos7/home:/home/nicole \
		-e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-p 2200:22 \
		-p 8888:8888 \
		centos7_dev bash