#!/bin/bash

deploy_gdal() {
    VERSION=$1
    WORKSPACE=$2
    OUTPUT=$3

    # build and package gdal.sh
    pushd "$WORKSPACE" || exit 1

    curl "http://download.osgeo.org/gdal/$VERSION/gdal-$VERSION.tar.gz" -s -o - | tar zxf -
    pushd "gdal-$VERSION" || exit 1

    ./configure --prefix="$OUTPUT" --enable-static=no --without-jasper --with-libkml="$OUTPUT"
    make
    make install

    pushd "$OUTPUT" || exit 1
    tar -czf "GDAL-$VERSION.tar.gz" ./*

    if [[ $S3_BUCKET && $AWS_ACCESS_KEY_ID && $AWS_SECRET_ACCESS_KEY ]]; then
        aws s3 cp --acl public-read "GDAL-$VERSION.tar.gz" "s3://$S3_BUCKET/$STACK/GDAL/"
    fi
}
