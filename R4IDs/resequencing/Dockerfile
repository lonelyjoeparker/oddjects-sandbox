# The 'test' container to monitor a directory and BLAST 
# reads against DBs from 'training' container, writing out
# the result to a text file readable by the 'visualisation' container.
#
# Usage:
# docker run -v ~/Public/test_r4ids_resequencing_input/:/input_resequencing -v ~/Public/test_r4ids_output/:/blast_db -v ~/Public/test_r4ids_resequencing_web/:/output_web raids-requencing
# 
# 	Where:	
#		/input_resequencing		: dir to monitor for new reads e.g. ont-albacore output
#		/blast_db				: location of the BLAST databases and blast_db.conf file; set up by hub.docker.com/lonelyjoeparker/r4ids:r4ids-training-v0.x
#		/output_web				: location of the www dir where blast data is written for hub.docker.com/lonelyjoeparker/r4ids:r4ids-visualisation-v0.x

#FROM ubuntu:xenial
#FROM python:2.7-slim
#FROM simonalpha/ncbi-blast-docker:2.2.30plus

FROM openjdk:8 

MAINTAINER Joe Parker <joe@lonelyjoeparker.com>

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# volume to look for blast DB
VOLUME /blast_db

# volume to monitor for new reads
VOLUME /input_resequencing

# volume to place web outputs in
VOLUME /output_web

# Download & install BLAST
RUN mkdir /opt/blast \
      && apt-get update && apt-get install -y ncbi-blast+   

ENV PATH /opt/blast/bin:$PATH

# set default behaviour
#CMD ["/usr/bin/java", "-v"]  
#CMD ["blastn", "-h"]
#ENTRYPOINT ["bash", "/app/run_resequencing_analysis.sh"]	# works fine
#CMD java -version # doesn't work if ncbi image is also imported

ENTRYPOINT ["java","-jar","./SimplifiedWatchDir.jar","/input_resequencing","fasta","/bin/bash","/app/run_resequencing_analysis.sh","/output_web"]
