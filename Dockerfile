FROM centos/php-72-centos7

USER 0

ENV COMPOSER_ALLOW_XDEBUG=1

# Install Apache httpd and PHP
RUN yum install -y --setopt=tsflags=nodocs epel-release && \
    INSTALL_PKGS="sclo-php72-php-pecl-redis4 \
                  sclo-php72-php-pecl-http sclo-php72-php-pecl-xdebug \ 
                  sclo-php72-php-pecl-amqp sclo-php72-php-pecl-msgpack \
                  sclo-php72-php-pecl-memcached sclo-php72-php-pecl-lzf \
                  sclo-php72-php-pecl-imagick sclo-php72-php-pecl-igbinary \
                  jpegoptim pngquant" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --nogpgcheck && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

ADD php.d/* /etc/opt/rh/rh-php72/php.d/

# Add Composer
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/master/web/installer -O - -q | php -- --quiet --install-dir=/usr/bin --filename=composer && \
    rm -Rf /opt/app-root/src/.composer && \
    mkdir -p /var/log/httpd24/xdebug/ && \
    chmod 755 /var/log/httpd24/xdebug/ && \
    yum install -y epel-release && \
    yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm && \
    yum install -y ffmpeg

# Add platform.sh

RUN curl -L https://github.com/platformsh/platformsh-cli/releases/download/v3.38.1/platform.phar > /usr/bin/platform && \
    chmod 755 /usr/bin/platform

USER 1001
