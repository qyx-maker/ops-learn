#!/bin/bash

VERSION="1.28.2"
FILENAME="nginx"
SOURCE_PACKAGE="${FILENAME}-${VERSION}.tar.gz"
SOURCE_DIR="${FILENAME}-${VERSION}"

. /etc/os-release

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
#3.安装编译环境
if [[ "$ID" == "rhel" || "$ID" == "centos" || "$ID" == "rocky" ]]; then
	if ! test `rpm -qa pcre-devel`; then
		dnf install -y gcc-c++ openssl-devel zlib-devel pcre-devel
	fi
	NGINX_SERVICE=/usr/lib/systemd/system/nginx.service
elif [[ "$ID" == "debian" || "$ID" == "ubuntu" ]]; then
	apt install -y libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev
	NGINX_SERVICE=/lib/systemd/system/nginx.service
fi

#4.进入解压目录
cd ${SOURCE_DIR}

#5.创建nginx系统用户
id ${FILENAME} &>/dev/null
if [ $? -ne 0 ]; then
	useradd -M -r -s /sbin/nologin ${FILENAME}
fi

#6.配置nginx服务
./configure \
--prefix=/usr/local/nginx \
--user=${FILENAME} \
--group=${FILENAME} \
--sbin-path=/usr/local/nginx/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/run/nginx.pid \
--error-log-path=/usr/local/nginx/logs/error.log \
--http-log-path=/usr/local/nginx/logs/access.log \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_sub_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--with-threads \
--with-file-aio \
--with-pcre \
--with-stream

#7.编译安装nginx
make && make install

#8.创建服务文件
cat > ${NGINX_SERVICE} <<EOF
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStart=/usr/local/nginx/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/usr/bin/bash -c "/usr/bin/kill -s HUP $(/usr/bin/cat /run/nginx.pid)"
#ExecStop=/usr/bin/bash -c "/usr/bin/kill -s TERM $(/usr/bin/cat /run/nginx.pid)"
ExecStop=/usr/local/nginx/sbin/nginx -s quit

[Install]
WantedBy=multi-user.target
EOF

#9.启动服务
echo "$(hostname -I)" > /usr/local/nginx/html/index.html
systemctl daemon-reload
systemctl start nginx

#10.配置防火墙
case "$ID" in
	"rhel" | "centos" | "rocky")
		firewall-cmd --list-service | grep http
		if [ $? -ne 0 ]; then
			firewall-cmd --permanent --add-service=http --add-service=https
			firewall-cmd --reload
		fi
		;;
	"debian" | "ubuntu")
		ufw allow http
		ufw allow https
		ufw reload
		;;
	*)
		exit 1
		;;
esac

#11.验证服务
curl localhost
