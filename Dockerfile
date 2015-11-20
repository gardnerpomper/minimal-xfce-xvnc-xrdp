# This Dockerfile is used to build an xfce image based on Centos

FROM centos:centos7
MAINTAINER Gardner Pomper "gardner@networknow.org"
# based on Tobias Schneck "tobias.schneck@consol.de"
#
# ----- xvnc / xrdp / xfce installation
#
RUN yum -y install epel-release		&&\
        yum -y update				&&\
        yum clean all
RUN yum --enablerepo=epel -y -x gnome-keyring --skip-broken groups install "Xfce" "Fonts" &&\
        yum clean all
RUN yum -y install sudo tigervnc-server xrdp wget net-tools unzip	&&\
        yum clean all
#
# ----- create a non-root user (me) to log in as
# ----- create a temporary home directory because docker has
# ----- problems when the owning UID is changed, so the directory
# ----- will be moved to /home/me after the UID is changed
# ----- in runas_me.sh
#
RUN mkdir /dhome							&& \
    useradd me  -G wheel -d /dhome/me			&& \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# xvnc server port, if $DISPLAY=:1 port will be 5901
EXPOSE 5901 3389

COPY xstartup /dhome/me/.vnc/
COPY start.sh runas_me.sh /tmp/
RUN chmod +x  /dhome/me/.vnc/xstartup /tmp/*.sh /etc/xdg/xfce4/xinitrc
#
# ----- define default values for the VNC display
#
USER me
ENV DISPLAY=:1 DEPTH=24 GEOMETRY=1280x1024
#
# ----- must start container as root so that we can change
# ----- the UID for user "me"
#
USER root
ENTRYPOINT ["/tmp/runas_me.sh"]
CMD ["/tmp/start.sh"]
