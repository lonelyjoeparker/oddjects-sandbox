# The 'training' container to take an input set of fasta files 
# and build BLAST DBs from each
#
# run with e.g.
# docker run -v ~/Public/test_r4ids_training_input/:/input_training -v ~/Public/test_r4ids_output/:/blast_db raids-training
#
# 
# built on: NCBI BLAST+ 2.2.30+ Dockerfile
#
# https://github.com/simonalpha/ncbi-blast-docker
# https://github.com/simonalpha/ncbi-blast-docker/tree/master/ncbi-blast-2.2.30+
#
# Provide`s NCBI BLAST+ binaries, mainly for use with Galaxy Project dockerised runners

#FROM ubuntu:xenial
#FROM python:2.7-slim
FROM simonalpha/ncbi-blast-docker:2.2.30plus

MAINTAINER Joe Parker <joe@lonelyjoeparker.com>

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

VOLUME /input_training
VOLUME /blast_db

# Install any needed packages specified in requirements.txt
#RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Download & install BLAST
#RUN mkdir /opt/blast \
#      && apt-get update && apt-get install -y ncbi-blast+

#ENV PATH /opt/blast/bin:$PATH

# set default behaviour
ENTRYPOINT ["bash", "/app/setup_training_data.sh","foo"]
# an extra arg
CMD ["bar"]
