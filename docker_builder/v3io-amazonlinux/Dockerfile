
FROM amazonlinux:latest 

# Variables
ENV IGUAZIO_HOME /home/iguazio

ADD libdl.so.2  /lib64/libdl.so.2 
ADD libpthread.so.0  /lib64/libpthread.so.0 
ADD librt.so.1  /lib64/librt.so.1 
ADD libnuma.so.1  /usr/lib64/libnuma.so.1 
ADD libstdc++.so.6  /usr/lib64/libstdc++.so.6 
ADD libm.so.6  /lib64/libm.so.6 
ADD libgcc_s.so.1  /lib64/libgcc_s.so.1 
ADD ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2 
ADD v3io_daemon /bin/v3io_daemon
RUN chmod 755 /bin/v3io_daemon 
