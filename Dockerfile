FROM continuumio/anaconda3

ENV TZ=Asia/Tokyo

# Install libraries for installing wgrib2
RUN apt update \
  && apt upgrade -y \
  && apt install -y wget make build-essential gfortran zlib1g-dev

RUN conda install netcdf4 matplotlib pandas numpy xarray jupyterlab

# Download & Install wgrib2
RUN cd ~
RUN wget https://www.ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v3.1.1
RUN tar xvzf wgrib2.tgz.v3.1.1

ENV CC gcc
ENV FC gfortran

RUN cd grib2/ \
  && make \
  && cp wgrib2/wgrib2 /usr/local/bin/

RUN groupadd -g 1100 jupyter \
  && useradd -m -s /bin/bash -u 1100 -g 1100 jupyter

RUN mkdir -p /app \
  && chown -R jupyter:jupyter /app
WORKDIR /app
USER jupyter

EXPOSE 8888

ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser", "--NotebookApp.token=\"''\""]
CMD [ "--notebook-dir=/app" ]
