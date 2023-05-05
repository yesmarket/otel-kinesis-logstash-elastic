FROM localstack/localstack

RUN mkdir -p /etc/localstack/init/ready.d
COPY ./init-aws.sh /etc/localstack/init/ready.d/
RUN chmod +x /etc/localstack/init/ready.d/init-aws.sh
