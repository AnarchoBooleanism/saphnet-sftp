# saphnet-sftp
Simplified image for SFTP functionality to be used within the Sapphic Homelab/Home Server

This Docker image is based on the [Docker image](https://hub.docker.com/r/emberstack/sftp) provided by [emberstack/docker-sftp](https://github.com/emberstack/docker-sftp).

To run this container, run this command:
```sh
docker run -p 2222:22 \
  -e SFTP_USERNAME='sftp-user' \
  -v EXAMPLE-DIR:/home/sftp-user/sftp \
  ghcr.io/anarchobooleanism/saphnet-nginx:latest
```

This sets up an SFTP server, accessible through port 2222 on the host, sharing the directory as the root SFTP directory (e.g. `/home/test-user/my-directory`); to access the server, log in as the user `sftp-user`. You can optionally add a password by adding specifying environment variable `SFTP_PASSWORD` in your command.

Here is a highly simple configuration for Docker Compose:
```yaml
services:
  sftp-server: # Our saphnet-sftp container, here
    image: ghcr.io/AnarchoBooleanism/saphnet-sftp:latest
    environment:
      SFTP_USERNAME: my-sftp-user # Optional, defaults to "sftp-user"
      # Optional (but recommended), is recommended you set this via secret or
      # environment variable (e.g. ${SFTP_PASSWORD})
      SFTP_PASSWORD: my-sftp-password
    volumes:
      - sftp-ssh-data:/etc/ssh # For persistence of SSH identity keys, optional
      # The directory that is the root of what you want to share, note that
      # this should be mounted to $HOME/sftp, with $HOME being "/home/" + the
      # username specified in SFTP_UESRNAME
      - ./example-dir:/home/my-sftp-user/sftp
    ports:
      # Generally recommended to map the container's port 22 to port 2022/2222
      # on the host, to avoid conflicts with the host's SSH port
      - "2022:22"

volumes:
  sftp-ssh-data: # Optional, keeps SSH identity keys consistent between deployments
```

For another example on using this with Docker Compose, check out this [example configuration](compose.yaml).

## Extra notes

### On setting usernames

To set the username with which to log into the SFTP server, set the `SFTP_USERNAME` environment variable. By default, it is set to `sftp-user`. However, when setting the username, make sure the username is reflected in the container directory that you are mounting to, in this format: `/home/YOUR-USERNAME/sftp`. For example, if your username is `my-sftp-user`, mount your desired directory to share to the directory `/home/my-sftp-user/sftp`.

### On setting passwords

To set the password with which to log into the SFTP server, set the `SFTP_PASSWORD` environment variable. By default, it is blank; however, it is highly recommended that you set a password if the SFTP server is accessible outside the host.

### SSH identity key persistence

As SSH (Secure Shell) is used as the backend protocol for SFTP, the SFTP server is identified with SSH keys. These keys are generated when the container is started, and saved to `/etc/ssh/`. However, if nothing is mounted to `/etc/ssh/`, these keys will be lost when the Docker container is destroyed (e.g. when the image is updated and deployed). This will make it difficult for the client to verify the identity of the SFTP server, as these SSH keys are regenerated every time the Docker container is deployed. To stop this from happening, make sure to mount a volume or directory to `/etc/ssh/`, so that these keys are kept between deployments.
