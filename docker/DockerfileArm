FROM continuumio/anaconda3

ENV TZ=Asia/Tokyo

# Install libraries for installing wgrib2
RUN apt update \
  && apt upgrade -y \
  && apt install -y wget make build-essential gfortran zlib1g-dev python3-pip

RUN pip install --upgrade pip \
  && pip install netcdf4 matplotlib pandas numpy xarray jupyterlab

RUN groupadd -g 1100 deno \
  && useradd -m -s /bin/bash -u 1100 -g 1100 deno

RUN mkdir -p /app \
  && chown -R deno:deno /app
WORKDIR /app

# Download & Install wgrib2
RUN cd ~
RUN wget https://www.ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v3.1.1
RUN tar xvzf wgrib2.tgz.v3.1.1

RUN cd grib2/ \
  && sed -i -e "s/#export CC=gcc/export CC=gcc/g" makefile \
  && sed -i -e "s/#export FC=gfortran/export FC=gfortran/g" makefile \
  && sed -i -e "860 s/.\/configure/.\/configure --build=arm/g" makefile \
  && sed -i -e "936 s/.\/configure/.\/configure --build=arm/g" makefile

RUN cd grib2/ \
  && make \
  && cp wgrib2/wgrib2 /usr/local/bin/

EXPOSE 8888
USER deno
ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser", "--NotebookApp.token=\"''\""]
CMD [ "--notebook-dir=/app" ]
