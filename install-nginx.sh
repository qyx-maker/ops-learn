#!/bin/bash

VERSION="1.28.2"
FILENAME="nginx"
SOURCE_PACKAGE="${FILENAME}-${VERSION}.tar.gz"
SOURCE_DIR="${FILENAME}-${VERSION}"


#1.下载源码安装包
cd /usr/local/src
if [ ! -e ${SOURCE_PACKAGE} ] ; then
	wget https://nginx.org/download/${SOURCE_PACKAGE}
fi
#2.解压源码包
if [  -e ${SOURCE_DIR} ] ; then
	rm -rf ${SOURCE_DIR}
fi
tar -zxf ${SOURCE_PACKAGE}
