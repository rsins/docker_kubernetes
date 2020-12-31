# Set Base Image
FROM python:3.8

LABEL maintainer="Ravi Singh"

ENV TERM xterm-256color

# api server works on this port
EXPOSE 5050

# Set Working Directory in the container
WORKDIR /code

# Copy required files to working directory
COPY requirements.txt .
COPY api.py .

# Install python dependencies
RUN pip install -r requirements.txt

# Start below command when container is started
CMD [ "python", "./api.py" ]
