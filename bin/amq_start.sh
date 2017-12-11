VM=default
ENV=dev && \
DOCKER_HOME=$HOME && \
docker rm -fv activemq_$ENV && \
rm -rf ${HOME}/activemq_${ENV}/data && \
mkdir -p ${HOME}/activemq_${ENV}/data && \
chmod 777 ${HOME}/activemq_${ENV}/data && \
docker run -d \
           --restart='always' \
           --name=activemq_${ENV} \
           -p 61616:61616 \
           -p 8162:8162 \
           -v ${DOCKER_HOME}/activemq_${ENV}/data:/opt/apache-activemq-5.10.0/data:rw \
           activemq
