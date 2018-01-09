FROM ubuntu:16.04
MAINTAINER Satish Hegde <satish.hegde@wipro.com>

ENV ACCEPT_EULA=Y

# apt-get and system utilities
RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && apt-get install -y wget software-properties-common \
  curl apt-utils apt-transport-https debconf-utils gcc build-essential g++-5 \
  && rm -rf /var/lib/apt/lists/*

# Install SQL Server Command line tools
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list)"

#RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server tools
RUN apt-get update && apt-get install -y mssql-tools

# install SQL Server drivers
RUN apt-get install -y unixodbc-dev msodbcsql 

#Install MSSQL server & agent
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list)"

#curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list | tee /etc/apt/sources.list.d/mssql-server.list && apt-get update

#install SQL Server
RUN apt-get update && apt-get install -y mssql-server
RUN apt-get install -y mssql-server-agent
#RUN apt-get install -y mssql-server-fts

#Set the PATH Variables
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin:/opt/mssql/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

#Set the sql port
EXPOSE 1433

#Start the SQL Server
CMD ["/opt/mssql/bin/sqlservr"]
