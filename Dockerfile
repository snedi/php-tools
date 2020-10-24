FROM busybox

WORKDIR /tmp

RUN wget --no-check-certificate -q -O - https://composer.github.io/installer.sig > EXPECTED_CHECKSUM.txt

FROM php:7.4.11-cli

COPY ./composer-install.sh /usr/src/
COPY --from=0 /tmp/EXPECTED_CHECKSUM.txt /usr/src/EXPECTED_CHECKSUM.txt

WORKDIR /usr/src/

RUN chmod +x composer-install.sh && \
    ./composer-install.sh && \
    mv composer.phar /usr/local/bin/composer && \
    rm EXPECTED_CHECKSUM.txt && \
    rm composer-install.sh

CMD [ "php", "-v" ]
