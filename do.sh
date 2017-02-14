#! /bin/bash

IMG="skyperious" ;

TO_KILL=$(docker ps | grep "${IMG}" | cut -f1 -d' ') ;
if [ ! -z "${TO_KILL}" ] ; then
    docker kill "${TO_KILL}" ;
fi

docker build \
    --quiet \
    --tag "${IMG}" \
    . ;
docker run \
    --interactive \
    --tty \
    "${IMG}" \
    /bin/bash ;
