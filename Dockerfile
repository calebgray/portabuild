# The Most Generic Dockerfile. (ACHTUNG: dumps its full load on failure because this is for professionals that don't believe in standards but follow them anyway.)
FROM ubuntu
COPY . .
CMD ([ -x ./build.sh ] && ./build.sh) \
|| ([ -x ./build/ubuntu.sh ] && ./build/ubuntu.sh) \
|| ([ -x ./build/linux.sh ] && ./build/linux.sh) \
|| ([ -x /usr/sbin/init ] && /usr/sbin/init) \
|| (env && find /)