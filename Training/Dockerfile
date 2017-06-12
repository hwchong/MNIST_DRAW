# Base Image
FROM tensorflow/tensorflow:1.1.0

# Maintainer
MAINTAINER Hon Weng Chong <honwchong@gmail.com>
RUN pip install keras==1.2
RUN pip install coremltools
RUN rm -rf /notebooks/*
COPY notebooks/*.ipynb /notebooks/