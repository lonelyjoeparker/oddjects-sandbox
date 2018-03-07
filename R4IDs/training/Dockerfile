# The 'training' container to take an input set of fasta files 
# and build BLAST DBs from each
#
# NCBI BLAST+ 2.2.30+ Dockerfile
#
# https://github.com/simonalpha/ncbi-blast-docker
# https://github.com/simonalpha/ncbi-blast-docker/tree/master/ncbi-blast-2.2.30+
#
# Provide`s NCBI BLAST+ binaries, mainly for use with Galaxy Project dockerised runners

FROM ubuntu:xenial

MAINTAINER Joe Parker <joe@lonelyjoeparker.com>

# Download & install BLAST
RUN mkdir /opt/blast \
      && apt-get update && apt-get install -y ncbi-blast+

ENV PATH /opt/blast/bin:$PATH

# set default behaviour
WORKDIR /blast
CMD ["bash"]