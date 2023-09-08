
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y 

RUN apt-get install -y git cmake libboost-all-dev libhpdf-dev graphicsmagick libpango-1.0-0  libunwind-dev gcc gcc-mingw-w64 g++ g++-mingw-w64 perl


#Download and install Wt
RUN git clone https://github.com/emweb/wt.git && \
    cd wt && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    ldconfig

COPY LDmicroWt/ldmicro/CMakeLists.txt /LDmicroWt/ldmicro/
COPY LDmicroWt.conf /etc/apache2/sites-available/

RUN mkdir -p /etc/apache2/sites-enabled

RUN ln -s /etc/apache2/sites-available/LDmicroWt.conf /etc/apache2/sites-enabled/LDmicroWt.conf

RUN rm -f /etc/apache2/sites-enabled/000-default.conf

COPY LDmicroWt/ldmicro /LDmicroWt/ldmicro

WORKDIR /LDmicroWt/ldmicro

RUN mkdir build

WORKDIR /LDmicroWt/ldmicro/build

# RUN cmake  ..
RUN cmake ..

RUN ls -l /LDmicroWt/ldmicro/build/


EXPOSE 80

CMD cd /LDmicroWt/ldmicro/build && make && ./ldmicro.wt --docroot ./docroot --approot ./approot --http-address 0.0.0.0 --http-port 9090








