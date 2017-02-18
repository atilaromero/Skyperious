#! /bin/bash

# Constants

DB_FILE='main.db' ;
XFER_FILE='./xfer/export.tar.gz' ;

# Export

./venv/bin/skyperious export \
    --verbose \
    --type html \
    "${DB_FILE}" ;

# Archive

TAR_DIR=$(ls -d Export*/) ;
tar \
    --create \
    --verbose \
    --gzip \
    --file \
    "${XFER_FILE}" \
    "${TAR_DIR}" ;
