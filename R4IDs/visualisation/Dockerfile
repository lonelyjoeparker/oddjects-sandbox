# The 'visualisation' container to display the results from
# the 'test' container as a web page.
#
# run with e.g. 
# docker run -v ~/Public/test_r4ids_resequencing_web/:/www -p 80:80 r4ids-visualisation

# NOTE: mounting /www directly.. 
# output will be on http://localhost/KSF.html

FROM busybox
#FROM ubuntu:xenial
#FROM php:7.0-apache

# based on https://github.com/crccheck/docker-hello-world
MAINTAINER Joe Parker <joe@lonelyjoeparker.com>

# Copy the current directory contents into the container at /www
ADD src/ /www
ADD src/ /www_backup
ADD src/css /www/css
ADD src/js /www/js
ADD src/Highcharts-4.2.3 /www/Highcharts-4.2.3

# Create a basic webserver and sleep forever
CMD cp /www_backup/*html /www/; httpd -p 80 -h /www; tail -f /dev/null
