# The Most Generic Dockerfile. ACHTUNG: Lists Filesystem on Execution Failure Because This is... For Development Only!!!
FROM ubuntu
COPY . .
CMD '[ -x ./build.sh ] && ./build.sh \
    || [ -x ./build/ubuntu.sh ] && ./build/ubuntu.sh \
    || [ -x ./build/linux.sh ] && ./build/linux.sh \
    || [ -x /usr/sbin/init ] && /usr/sbin/init \
    || find /'
