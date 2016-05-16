FROM centos:centos7
MAINTAINER Nicole Neo <nicole@neo.my>

## ****Substitute username BELOW****
ENV USER=nicole
ENV PASSWORD=hello
ENV ROOTPASSWORD=hello
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# Local DNS resolving
RUN sed -i 's/hosts:      files dns/hosts:      files dns mdns4/g' /etc/nsswitch.conf
RUN yum install -y wget
# X11
RUN yum install -y libXext libXrender libXtst libXi xauth gettext curl openssh-server
# EPEL repo
RUN yum install -y epel-release openssl
RUN yum update -y
# Add user
RUN useradd -p $(openssl passwd -1 $PASSWORD) $USER
# Install git and which
RUN yum install -y git which
RUN yum group install -y "Development Tools"
RUN yum install -y vim-enhanced man sudo
RUN chown -hR $USER:$USER /home/$USER/
RUN echo "root:$ROOTPASSWORD" | chpasswd
# Enable core dumps
RUN mkdir -p /logs/cores
RUN chown $USER:$USER /logs/cores
RUN sed -i -e 's/ulimit -S -c 0/ulimit -c unlimited/g' /etc/profile
RUN sed -i -e 's/# No core files by default/# Core dumps/g' /etc/profile
# Add to sudoers
RUN  echo -e $USER '\tALL=(ALL)\tALL' >> /etc/sudoers
# LaTeX repo
RUN wget -q http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
RUN rpm -Uvh rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
RUN yum --enablerepo rpmforge search latex tetex
RUN yum install -y tetex-latex tetex-doc tetex-fonts
RUN yum install -y pandoc
RUN yum install -y lyx
RUN yum install -y initscripts openssh-clients
EXPOSE 22
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' -A
WORKDIR /tmp
RUN wget -q http://repo.continuum.io/archive/Anaconda3-4.0.0-Linux-x86_64.sh
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh
RUN /bin/bash Anaconda3-4.0.0-Linux-x86_64.sh -b -p /opt/conda
ENV PATH /opt/conda/bin:$PATH
RUN conda install jupyter
RUN conda update pyqt
RUN yum install -y net-tools
RUN mkdir /home/$USER/.ssh && chmod 700 /home/$USER/.ssh
RUN ssh-keygen -t rsa -q -f "/home/$USER/.ssh/id_rsa" -N ""
CMD ["/usr/sbin/sshd", "-D"]
# NetBeans
ADD jdk8.rpm /tmp
RUN rpm -ivh jdk8.rpm
ENV JAVA_HOME=/usr/java/latest/
ENV PATH=$PATH:$JAVA_HOME
RUN wget http://download.netbeans.org/netbeans/8.1/final/bundles/netbeans-8.1-linux.sh -O /tmp/netbeans.sh -q && \
    chmod +x /tmp/netbeans.sh && \
    echo 'Installing netbeans' && \
    /tmp/netbeans.sh --silent --state /tmp/state.xml && \
    rm -rf /tmp/*
ADD vars.sh /etc/profile.d/.
ADD init.sh /
ADD startnb.sh /
EXPOSE 8888
ENV QT_X11_NO_MITSHM=1
ENTRYPOINT ["/init.sh"]
