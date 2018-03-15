# The 'test' container to monitor a directory and BLAST 
# reads against DBs from 'training' container, writing out
# the result to a text file readable by the 'visualisation' container.
#
# NCBI BLAST+ 2.2.30+ Dockerfile
#
# https://github.com/simonalpha/ncbi-blast-docker
# https://github.com/simonalpha/ncbi-blast-docker/tree/master/ncbi-blast-2.2.30+
#
# Provide`s NCBI BLAST+ binaries, mainly for use with Galaxy Project dockerised runners

FROM ubuntu:xenial
#FROM python:2.7-slim
FROM openjdk:8 
FROM simonalpha/ncbi-blast-docker:2.2.30plus

MAINTAINER Joe Parker <joe@lonelyjoeparker.com>

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
#RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Download & install BLAST
#RUN mkdir /opt/blast \
#      && apt-get update && apt-get install -y ncbi-blast+ && apt-get update && apt-get install -y openjdk-7-jre   

#RUN mkdir /opt/blast \
#      && apt-get update && apt-get install -y ncbi-blast+ && apt-get update && apt-get install -y default-jre-headless   

ENV PATH /opt/blast/bin:$PATH

# set default behaviour
#CMD ["/usr/bin/java", "-v"]  
#CMD ["blastn", "-h"]
ENTRYPOINT ["bash", "/app/run_resequencing_analysis.sh"]	# works fine
CMD java -version # doesn't work if ncbi image is also imported