# Goal: An AL9 image that can be used for ATLAS development
# work and has CVMFS access to the ATLAS software stack.

# Start from the latest Alma Linux 9 base image
FROM almalinux:9

# Get libraries and utilties installed to run ATLAS software
RUN yum -y install sudo passwd yum-utils

# Add wsl utilities
RUN yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/wslutilities/RHEL_7/home:wslutilities.repo && yum install -y wslu

# Get CVMFS installed
RUN yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm && yum install -y cvmfs
RUN cvmfs_config setup
COPY default.local /etc/cvmfs/default.local

# Libraries, etc., needed for ATLAS software
RUN yum install -y https://linuxsoft.cern.ch/wlcg/el9/x86_64/wlcg-repo-1.0.0-1.el9.noarch.rpm
# && yum install -y HEP_OSlibs

# Get the startup scripts for ATLAS defined
RUN mkdir /etc/atlas-cern
COPY startup-atlas-sudo.sh /etc/atlas-cern/startup-atlas-sudo.sh
COPY startup-atlas.sh /etc/profile.d
COPY config-user.sh /etc/atlas-cern/config-user.sh
COPY sudoers-atlas-setup /etc/sudoers.d/sudoers-atlas-setup

# And WSL config
COPY wsl.conf /etc/wsl.conf