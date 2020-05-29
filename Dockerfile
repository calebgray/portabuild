# 
FROM ubuntu
COPY . .
CMD ./build.sh || ./build/ubuntu.sh || ./build/linux.sh || /usr/sbin/init




[ -x ./build.sh ] && ./build.sh \
	|| [ -x ./run.sh ] && ./run.sh \
	|| echo "Couldn't execute "
