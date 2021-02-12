# The first docker instruction must be a FROM instruction.
#
# FROM specifies the parent image upon which this image is built.
#
# Use an official python runtime as a parent image.
FROM python:2.7-slim

# Environment variables can be used in the Dockerfile. Note that they are not
# supported by all commands (i.e., RUN and CMD)
#
# They will also be added to the image. Be careful they do not overwrite /
# interfere with the image's env vars.
ENV OUTDIR=/app

# Copy the current directory contents to the container
COPY . ${OUTDIR}

# Set the working directory to /app
WORKDIR ${OUTDIR}

# RUN commands run in /bin/sh -c on Linux
#
# Run commands can be specified in "exec" form, which requires
# You to include a shell if you want to execute a shell script
#
# RUN ["/bin/bash" "-c" "echo $HOME"]
#
# Install any needed packages specified in requirements.txt
RUN ["pip", "install", "--trusted-host", "pypi.python.org", "-r", "requirements.txt"]

# EXPOSE tells the docker runtime what port the container listens on at runtime.
#
# NOTE: This does *NOT* publish the port. It's used as documentation for the
# person using the image - to tell them which ports are intended to be
# published.
EXPOSE 80

# CMD provides default command arguments for an executing container.
#
# There can only be one CMD instruction per Dockerfile. If there are multiple,
# the last one wins.
#
# Run app.py with tne conainer launches
#
# If the user specifies arguments to docker run they will be used to override
# the defaults specified in CMD.
#
# If ENTRYPOINT is specified, arguments to CMD will be appended. If ENTRYPOINT
# is *NOT* specified, CMD can be used to set the initial executable
# CMD [ "python", "app.py" ]

# ENTRYPOINT allows you to configure a container that will run as an executable.
#
# Command line arguments (CMD) will be appended to ENTRYPOINT.
#
# Add parameters to entry point that you don't want changed by CMD.
ENTRYPOINT [ "python", "app.py"]
