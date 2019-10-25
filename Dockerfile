ARG HUGO_VERSION=0.59.0

# Prefer Hugo as the base image, rather than alpine directly. Should hopefully
# help with debugging mozjpeg builds if the image changes in future.
FROM registry.gitlab.com/pages/hugo:${HUGO_VERSION} as builder

RUN apk --update add \
    autoconf \
    automake \
    build-base \
    libtool \
    pkgconf \
    nasm

# https://github.com/mozilla/mozjpeg/blob/master/BUILDING.md
# Told to use autotools instead   - https://en.wikipedia.org/wiki/GNU_Autotools
# Apparently pkg-config is needed - https://askubuntu.com/questions/468661/
ARG MOZJPEG_VERSION=3.3.1
RUN wget -O /tmp/mozjpeg.tar.gz https://github.com/mozilla/mozjpeg/archive/v${MOZJPEG_VERSION}.tar.gz \
    && tar -xvf /tmp/mozjpeg.tar.gz -C /tmp \
    && autoreconf -fiv /tmp/mozjpeg-${MOZJPEG_VERSION} \
    && /tmp/mozjpeg-${MOZJPEG_VERSION}/configure --prefix /opt/mozjpeg \
    && make install \
    && /opt/mozjpeg/bin/cjpeg -version

# Build the release image
FROM registry.gitlab.com/pages/hugo:${HUGO_VERSION}
RUN apk --update --no-cache add pngquant
COPY --from=builder /opt/mozjpeg /opt/mozjpeg/
ADD build.sh /opt
CMD sh /opt/build.sh