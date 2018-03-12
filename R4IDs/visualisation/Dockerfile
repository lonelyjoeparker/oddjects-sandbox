# The 'visualisation' container to display the results from
# the 'test' container as a web page.

# basic PHP + Apache 
# (see https://docs.docker.com/samples/library/php/#create-a-dockerfile-in-your-php-project-1)

FROM ubuntu:xenial
FROM php:7.0-apache
#COPY config/php.ini /usr/local/etc/php/
#COPY src/ /var/www/html/

MAINTAINER Joe Parker <joe@lonelyjoeparker.com>

# Set the working directory to /var/www/html/
WORKDIR /var/www/html/

# Copy the current directory contents into the container at /var/www/html/
ADD . /var/www/html/

# Install any needed packages specified in requirements.txt
#RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# set default behaviour
# CMD ["bash"]
# sci-fest.php should be the index