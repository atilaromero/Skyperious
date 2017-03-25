# OS

FROM    ubuntu:xenial
RUN     apt-get update \
&&      apt-get upgrade \
            --yes ;

# Python

RUN     apt-get install \
            --yes \
            git \
            python2.7 \
            virtualenv ;

# Python packages

ADD     requirements.txt /code/requirements.txt
RUN     virtualenv \
            --no-site-packages \
            --python=$(which python2.7) \
            /code/venv ;
RUN     /code/venv/bin/pip install \
            --requirement /code/requirements.txt ;

# Setup

WORKDIR /code
COPY    main.db .
