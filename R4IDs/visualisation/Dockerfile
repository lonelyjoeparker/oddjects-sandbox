# The 'visualisation' container to display the results from
# the 'test' container as a web page.

FROM busybox
#FROM ubuntu:xenial
#FROM php:7.0-apache
#COPY config/php.ini /usr/local/etc/php/
ADD src/ /www
ADD src/css /www/css
ADD src/js /www/js
ADD src/Highcharts-4.2.3 /www/Highcharts-4.2.3

# based on https://github.com/crccheck/docker-hello-world
MAINTAINER Joe Parker <joe@lonelyjoeparker.com>

# Set the working directory to /var/www/html/
#WORKDIR /var/www/html/

# Copy the current directory contents into the container at /www
#ADD css /www/css
#ADD js /www/js
#ADD Highcharts-4.2.3 /www/Highcharts-4.2.3
# data dir
#ADD data /www/data

# outputs
#ADD index.html /www/index.html
#ADD KSF.html /www/KSF.html
#ADD hello.php /www/hello.php	#doesn't serve...

# copy outputs from resequencing to web too
VOLUME /output_web

# Install any needed packages specified in requirements.txt
#RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 8000

# set default behaviour
# CMD ["bash"]
# Create a basic webserver and sleep forever
CMD ln -s /output_web/* /www; httpd -p 80 -h /www; tail -f /dev/null
# run with e.g. 
# docker run -p 80:80 r4ids-visualisation
# output will be on http://localhost/KSF.html

