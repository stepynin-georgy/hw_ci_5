FROM centos:7

RUN mkdir /python-api

# Set the working directory to /python_api
WORKDIR /python-api

COPY . .

RUN chmod +x repository-check.sh  && ./repository-check.sh

# Install Python and dependencies
RUN yum -y install wget make gcc openssl-devel bzip2-devel libffi-devel && \
    cd /tmp/ && \
    wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz && \
    tar xzf Python-3.7.9.tgz && \
    cd Python-3.7.9 && \
    ./configure --enable-optimizations && \
    make altinstall && \
    ln -sfn /usr/local/bin/python3.7 /usr/bin/python3.7 && \
    ln -sfn /usr/local/bin/pip3.7 /usr/bin/pip3.7 && \
    python3.7 -m pip install --upgrade pip

RUN pip3 install flask flask-jsonpify flask-restful

# Set the entry point to run the script
CMD ["python3.7", "/python-api/python-api/python-api.py"]