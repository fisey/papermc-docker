FROM openjdk:13-alpine AS gosu

COPY install-gosu-alpine.sh /

RUN /install-gosu-alpine.sh && rm /install-gosu-alpine.sh

# --------------------------------------------------------------------------- #

FROM openjdk:13-alpine AS build

# Version 1.15.2
ENV APP_BUILD=79
ENV APP_VERSION=1.15.2

RUN mkdir /usr/share/java

# download server.jar directly
RUN \
  test -f /usr/share/java/paper.jar || \
  wget --output-document=/usr/share/java/paper.jar \
  https://papermc.io/api/v1/paper/${APP_VERSION}/${APP_BUILD}/download

WORKDIR /usr/share/java

RUN \
  test -f cache/patched_${APP_VERSION}.jar || \
  /opt/openjdk-13/bin/java -jar paper.jar

RUN \
  test -f /usr/share/java/papermc.jar || \
  mv /usr/share/java/cache/patched_${APP_VERSION}.jar /usr/share/java/papermc.jar

# --------------------------------------------------------------------------- #

FROM openjdk:13-alpine AS app

ENV APP_UID=1001
ENV APP_GID=1001
ENV APP_MEMORY=4096M

WORKDIR /minecraft-data

COPY --from=gosu \
  /usr/local/bin/gosu \
  /usr/local/bin/gosu

COPY --from=build \
  /usr/share/java/papermc.jar \
  /usr/share/java/papermc.jar

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# [EOF]

