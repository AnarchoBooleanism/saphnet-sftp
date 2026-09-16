FROM emberstack/sftp:build-5.1.72@sha256:9ac1eada318326673beb88eeaa92ad11e1436d8d2ebdf4bfb633618c73ed8339

# To be passed from Github Actions
ARG GIT_VERSION_TAG=unspecified
ARG GIT_COMMIT_MESSAGE=unspecified
ARG GIT_VERSION_HASH=unspecified

# Copy repo contents to image
COPY ./saphnet-entrypoint.sh /

# Write any Git-related info
RUN printf "%s\n" "$GIT_VERSION_TAG" > GIT_VERSION_TAG.txt
RUN printf "%s\n" "$GIT_COMMIT_MESSAGE" > GIT_COMMIT_MESSAGE.txt
RUN printf "%s\n" "$GIT_VERSION_HASH" > GIT_VERSION_HASH.txt

EXPOSE 22

# Environment variables
ENV SFTP_USERNAME="sftp-user"
ENV SFTP_PASSWORD=""

ENTRYPOINT [ "/saphnet-entrypoint.sh" ]
