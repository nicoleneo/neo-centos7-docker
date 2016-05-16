CentOS 7 (64-bit) dev machine in Docker
=======================================
Docker containers are lightweight VMs on top of Linux[^Linux] that are **easy to rebuild on demand** and **quick to launch**.

[^Linux]: On Windows and OS X, you need to go through [boot2docker](http://boot2docker.io/) which spawns a lightweight VM on which Docker can be run. N.B. OS X is based on *Unix* not Linux.

The dependencies and libs are installed on top of a 64-bit CentOS 7 base image using the instructions defined in the **Dockerfile**. Rebuilding it takes mere *minutes* as Docker saves snapshots of incremental changes.

Building
--------
This command will build a Docker container named neo-centos7-docker with the tag latest using the instructions specified in the Dockerfile.

	git clone https://github.com/nicoleneo/neo-centos7-docker.git
	cd neo-centos7-docker/build
	
**Download JDK 8** (Linux x64 RPM) from [Oracle](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html). Put the file in neo-centos7-docker/build and rename it to **jdk8.rpm**

	sudo docker build -t neo-centos7-docker:latest . 
	
To make changes in the container, first try them out in the running container *before* finalising and putting the commands in the Dockerfile. 

After making changes in the Dockerfile, rebuild using the above command.

Running
-------
Use the script to run it

	sudo ./run.sh 

You'll be presented with the bash prompt of the container

Users
-----
Edit this parameter in the Dockerfile to use your own username. Change the default password for your user account as well as the root password.

	## ****Substitute username BELOW****
	ENV USER=nicole
	ENV PASSWORD=hello
	ENV ROOTPASSWORD=hello


This starts sshd as root and creates a login shell (the l flag) as the user nicole.

	#!/bin/bash
	
	service sshd start
	su -l - nicole

During the first time run, run these Git config commands and these settings will be saved in your home directory.

	git config --global user.name "Nicole Neo"
	git config --global user.email "<myemail>"

Shared Folders
--------------
Change this line in **run.sh**:

	-v ~/neo-centos7-docker/home:/home/{USER}

Shared folders are mounted. The **home** directory in this folder will be mounted as ~ (the user {USER}'s home dir) in the container. 

#### Docker containers **do not persist state** i.e. anything created outside the shared folder will be **gone** once the container exits!

All user preferences will be stored here. Any **permanent changes** (e.g. copying over libs) need to be made in the **Dockerfile**.



Root
----
The root password has been set as {ROOTPASSWORD} defined at the top of the Dockerfile. Run

	su

sudo should work now that the user has been added to the sudoers file.

Pandoc
------
Pandoc is a utility to convert text files from one format to another. E.g. to convert README.md from Markdown to README.html in HTML, run:

	pandoc -f markdown README.md -s -o README.html -t html

To convert from Markdown to PDF (using LaTeX to render the PDF):

	pandoc -f markdown README.md -s -o README.pdf
	
NetBeans
--------

I have managed to get X11 to work. **Inside** the running container, run

	netbeans &

A NetBeans will open on your local machine using X11.

The ampersand puts it in the background. Other GUI applications can be run this way as well.

Aliases for NetBeans have been set up.

	startnb
	killnb
	restartnb

startnb will start NetBeans GUI as a background process and store its PID.

killnb will kill the NetBeans process (PID is stored as an env var $NBID).

restartnb is killnb then startnb

### Updating NetBeans
Run this command each time NetBeans notifies that there are updates. Ctrl-C or close the NetBeans window after it's done updating.

    netbeans --update-all --modules --refresh

Jupyter Notebook
----------------
Jupyter notebook can be run in the background using:

	jupyternb &

Go to http://localhost:8888 on the host machine to open the Jupyter Notebook server

Spyder
------
It's a large GUI application relying on PyQt.

	spyder &

SSH
---
SSH into the container if you need more 'windows' e.g. new terminals or to open more GUI applications.
 
Get the IP address of the running Docker container

	$ ifconfig
	eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
	          inet addr:172.17.0.2  Bcast:0.0.0.0  Mask:255.255.0.0

Open another Terminal window and SSH into the machine with X11 enabled (the X flag).

	ssh -X nicole@172.17.0.2

It takes a long time to connect. Enter your password when prompted. New GUI windows can also be spawned from within the SSH session.

Connecting to the container's ports
-----------------------------------
The container's ports need to be exposed to make them visible to the outside world. Add a new argument in run.sh for each new port that needs to be exposed. UDP ports need the udp flag specified after the port number. 

	-p 5555:5555/udp \
	-p 2200:22 \

Data from UDP port 5555 of the *host* (i.e. localhost:5555) will redirect to 5555 of the *container* i.e. 172.17.0.2:6407 . The same port numbers can only be used if there are **no port conflicts on the host**.

SSH using port 2200 on the *host* (i.e. localhost:2200) will redirect to port 22 of the *container* i.e. 172.17.0.2:22 .

Logs
----
The /logs folder has been set up to be shared with the host. The logs directory in the host (same level dir as home) maps to /logs in the container. This will persist the core for each start up. 

Coredumps
---------
The Dockerfile has steps to add the coredump settings. However the /proc system directory cannot be modified during the build. /proc will be mounted as writeable and the necessary changes to enable coredumps are done on that dir each start up (in init.sh). 

Corredump files will be saved in /logs/cores

Updating CentOS
---------------
Pull the latest image from the Docker repo. This will fix [systemd errors](https://seven.centos.org/2015/12/fixing-centos-7-systemd-conflicts-with-docker/).

    sudo docker pull centos:centos7


