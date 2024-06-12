ARG GLUE_VERSION=4.0.0
FROM public.ecr.aws/glue/aws-glue-libs:glue_libs_${GLUE_VERSION}_image_01

ARG GLUE_VERSION
ARG UID=1000
ARG GID=${UID:-1000}

USER root
# Linux systems require the user ID (UID) to match between host and container
RUN groupadd --gid ${GID} glue
RUN usermod --uid ${UID} --gid glue glue_user
RUN find /tmp/ -maxdepth 1 -uid 10000 -exec chown --recursive --verbose glue_user:glue '{}' ';'
USER glue_user

COPY <<EOF /home/glue_user/.aws/config
[profile localstack]
endpoint_url = http://localstack:4566
output = table
region = xx-fake-0
aws_access_key_id = AACCESSKID
aws_secret_access_key = S3CR3T

EOF

ENV DISABLE_SSL=foobar

ENTRYPOINT [ "bash", "-l", "-c", "exec $0 $@"]
CMD ["bash"]
