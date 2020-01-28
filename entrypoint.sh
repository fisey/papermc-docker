#!/bin/sh
set -eu

echo "APP_UID: ${APP_UID}"
echo "APP_GID: ${APP_GID}"
echo "APP_MEMORY: ${APP_MEMORY}"

APP_ARGS="-XX:ParallelGCThreads=7 -Xmx${APP_MEMORY} -Xms${APP_MEMORY} -jar /usr/share/java/papermc.jar"

echo "minecraft:x:${APP_UID}:${APP_GID}:The Docker User:/home/minecraft:/bin/sh" >> /etc/passwd
echo "minecraft:x:${APP_GID}:" >> /etc/group

mkdir --parents "/home/minecraft"
chown "${APP_UID}:${APP_GID}" "/home/minecraft"

cd "/minecraft-data"

echo "eula=true" > eula.txt

exec gosu minecraft java ${APP_ARGS} "$@"

# [EOF]

