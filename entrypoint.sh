#!/bin/bash
set -e

#set -x

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}

DRAWIO_USER=drawio

install_drawio() {
  echo "Installing drawio-wrapper..."
  install -m 0755 /var/cache/drawio/drawio-wrapper /target/
  echo "Installing drawio..."
  ln -sf drawio-wrapper /target/drawio
}

uninstall_drawio() {
  echo "Uninstalling drawio-wrapper..."
  rm -rf /target/drawio-wrapper
  echo "Uninstalling drawio..."
  rm -rf /target/drawio
}

create_user() {
  # create group with USER_GID
  if ! getent group ${DRAWIO_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${DRAWIO_USER} >/dev/null 2>&1
  fi

  # create user with USER_UID
  if ! getent passwd ${DRAWIO_USER} >/dev/null; then
    adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
      --gecos 'Drawio' ${DRAWIO_USER} >/dev/null 2>&1
  fi
  chown ${DRAWIO_USER}:${DRAWIO_USER} -R /home/${DRAWIO_USER}
  adduser ${DRAWIO_USER} sudo
}

grant_access_to_video_devices() {
  for device in /dev/video*
  do
    if [[ -c $device ]]; then
      VIDEO_GID=$(stat -c %g $device)
      VIDEO_GROUP=$(stat -c %G $device)
      if [[ ${VIDEO_GROUP} == "UNKNOWN" ]]; then
        VIDEO_GROUP=drawiovideo
        groupadd -g ${VIDEO_GID} ${VIDEO_GROUP}
      fi
      usermod -a -G ${VIDEO_GROUP} ${DRAWIO_USER}
      break
    fi
  done
}

launch_bash() {
  cd /home/${DRAWIO_USER}
#  exec sudo -HEu ${DRAWIO_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" xcompmgr -c -l0 -t0 -r0 -o.00 &
#  exec sudo -HEu ${DRAWIO_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" $@
  #exec sudo -HEu ${DRAWIO_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" /bin/bash
  exec sudo -HEu ${DRAWIO_USER} /bin/bash
}

case "$1" in
  install)
    install_drawio
    ;;
  uninstall)
    uninstall_drawio
    ;;
  *|bash)
    create_user
    #grant_access_to_video_devices
    echo "$1"
    echo "launch draw.io by invoking 'drawio' at the bash prompt:"
    launch_bash $@
    ;;
  # *)
  #   exec $@
  #;;
esac
