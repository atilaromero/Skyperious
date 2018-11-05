# OS

FROM    ubuntu:18.04
RUN     apt-get update
RUN     apt-get install \
            --yes \
            git \
            python2.7 
RUN apt-get install -y --no-install-recommends python-pip
RUN apt-get install -y --no-install-recommends \
      python-setuptools \
      python-wxgtk3.0 \
      python-dbus \
      python-gobject \
      dbus \
      dbus-x11

RUN mkdir -p /var/lib/dbus/
RUN dbus-uuidgen > /var/lib/dbus/machine-id

ENV NO_AT_BRIDGE=1

# Python packages

ADD     requirements.txt /code/requirements.txt
RUN     pip install \
            --requirement /code/requirements.txt ;

# Setup

