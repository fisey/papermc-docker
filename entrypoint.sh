#!/bin/sh
set -eu

echo "APP_UID: ${APP_UID}"
echo "APP_GID: ${APP_GID}"
echo "APP_MEMORY: ${APP_MEMORY}"

APP_ARGS="-Xms${APP_MEMORY} -Xmx${APP_MEMORY} -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -jar /usr/share/java/papermc.jar nogui"

echo "minecraft:x:${APP_UID}:${APP_GID}:The Docker User:/home/minecraft:/bin/sh" >> /etc/passwd
echo "minecraft:x:${APP_GID}:" >> /etc/group

mkdir --parents "/home/minecraft"
chown "${APP_UID}:${APP_GID}" "/home/minecraft"

cd "/minecraft-data"

echo "eula=true" > eula.txt

exec gosu minecraft java ${APP_ARGS} "$@"

# [EOF]

