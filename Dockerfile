# References:
#   https://gist.github.com/demaniak/c56531c8d673a6f58ee54b5621796548
#   https://github.com/mdouchement/docker-zoom-us
#   https://hub.docker.com/r/solarce/zoom-us
#   https://github.com/sameersbn/docker-skype
FROM debian:buster
MAINTAINER olberger

ENV DEBIAN_FRONTEND noninteractive

# Refresh package lists
RUN apt-get update
RUN apt-get -qy dist-upgrade

# Dependencies for the client .deb

RUN apt-get install -qy  --no-install-recommends curl ca-certificates sudo

RUN apt-get install -qy  --no-install-recommends \
   libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libappindicator3-1 libsecret-1-0 libx11-xcb1 libxcb-dri3-0 libdrm2 libgbm1 libasound2

#    pulseaudio apt-utils apt-transport-https \
#    libatk-bridge2.0-0 libcups2 libgtk-3-0 libnspr4 libnss3 libxss1 gpg libsecret-1-0

#  libasound2 libcairo2 libcups2 libgdk-pixbuf2.0-0 \
# libpango-1.0-0 libpangocairo-1.0-0 \
# libx11-xcb1 libxcomposite1 libxcomposite1 \
# libxkbfile1
# desktop-file-utils lib32z1 \
#   libx11-6 libegl1-mesa libxcb-shm0 \
#   libglib2.0-0 libgl1-mesa-glx libxrender1 libxcomposite1 libxslt1.1 \
#   libgstreamer1.0-0 libgstreamer-plugins-base1.0-0 libxi6 libsm6 \
#   libfontconfig1 libpulse0 libsqlite3-0 \
#   libxcb-shape0 libxcb-xfixes0 libxcb-randr0 libxcb-image0 \
#   libxcb-keysyms1 libxcb-xtest0 ibus ibus-gtk \
#   libnss3 libxss1 xcompmgr

ARG DRAWIO_DESKTOP_URL="https://github.com/jgraph/drawio-desktop/releases/download/v13.9.9/draw.io-amd64-13.9.9.deb"

# Grab the client .deb
# Install the client .deb
# Cleanup
RUN curl -sSL $DRAWIO_DESKTOP_URL -o /tmp/draw.io.deb
RUN dpkg -i /tmp/draw.io.deb
RUN apt-get -f install

COPY scripts/ /var/cache/drawio/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
