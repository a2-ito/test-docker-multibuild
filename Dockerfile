FROM arm32v7/alpine:3.10

COPY qemu-arm-static /usr/bin

# add repository
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# install VNC & the desktop system
RUN \
  apk --update --no-cache add x11vnc shadow xvfb \
        exo xfce4-whiskermenu-plugin gtk-xfce-engine thunar numix-themes-xfwm4 \
        xfce4-panel xfce4-session xfce4-settings xfce4-terminal xfconf xfdesktop xfwm4 xsetroot \
        ttf-dejavu numix-themes-gtk2 adwaita-icon-theme \
        chromium

# install supervisor and sudo
RUN \
  apk --update --no-cache add supervisor sudo && \
  addgroup alpine && \
  adduser -G alpine -s /bin/sh -D alpine && \
  echo "alpine:alpine" | /usr/sbin/chpasswd && \
  echo "alpine    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# install Japanese environment
RUN \
  apk --no-cache add font-ipa ibus-anthy

# clean-up
RUN \
  rm -Rf /apk /tmp/* /var/cache/apk/*

ADD etc /etc
WORKDIR /home/alpine
EXPOSE 5900
USER alpine
CMD ["sudo","/usr/bin/supervisord","-c","/etc/supervisord.conf"]
