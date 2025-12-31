# RHCSA EX200 Practice Lab - Rocky Linux 9
FROM rockylinux:9

# Install systemd and basic packages
RUN dnf -y update && dnf -y --allowerasing install \
    systemd \
    systemd-resolved \
    openssh-server \
    openssh-clients \
    sudo \
    vim \
    nano \
    less \
    man-db \
    man-pages \
    bash-completion \
    tar \
    gzip \
    bzip2 \
    xz \
    findutils \
    grep \
    sed \
    gawk \
    procps-ng \
    psmisc \
    net-tools \
    iproute \
    iputils \
    bind-utils \
    hostname \
    passwd \
    shadow-utils \
    util-linux \
    coreutils \
    cronie \
    at \
    rsyslog \
    httpd \
    nfs-utils \
    lvm2 \
    parted \
    gdisk \
    xfsprogs \
    e2fsprogs \
    acl \
    attr \
    policycoreutils \
    policycoreutils-python-utils \
    selinux-policy-targeted \
    setroubleshoot-server \
    firewalld \
    chrony \
    tuned \
    dnf-plugins-core \
    && dnf clean all

# Enable systemd
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;

# Enable essential services
RUN systemctl enable sshd crond rsyslog firewalld chronyd

# Set root password to 'redhat'
RUN echo 'root:redhat' | chpasswd

# Create exam directories
RUN mkdir -p /exam/{scripts,archives} /shared /webcontent /mnt/{data1,examdata,nfsdata}

# Create a virtual disk file for LVM practice (500MB)
RUN dd if=/dev/zero of=/var/exam-disk.img bs=1M count=500 2>/dev/null

# Create userlist for scripting tasks
RUN echo -e "testuser1\ntestuser2\ntestuser3" > /exam/userlist.txt

# Configure SSH
RUN ssh-keygen -A
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create exam environment marker
RUN echo "RHCSA Practice Lab - Server" > /etc/exam-server

# Set up persistent journal directory
RUN mkdir -p /var/log/journal

VOLUME ["/sys/fs/cgroup"]
STOPSIGNAL SIGRTMIN+3

CMD ["/usr/sbin/init"]
