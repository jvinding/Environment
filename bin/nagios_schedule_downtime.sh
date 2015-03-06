#!/bin/bash -eu

## HOSTS=(api-production3 api-production4 api-qa1 api-staging1 api-staging2 bucket1 crawl-prod1 crawl-qa1 crawl-staging1 db-production db-production1 db-qa1 db-staging1 db-staging2 logstash metadata-db metadata-production metadata-qa metadata-staging redis-prod1)
HOSTS=(kamino)

if [ -z "${NAGIOS_USERNAME:-}" ] || [ -z "${NAGIOS_PASSWORD:-}" ]; then
    echo "NAGIOS_USERNAME and NAGIOS_PASSWORD must be set"
    exit 1
fi

NAGIOS_HOST=admin.closely.com
NAGIOS_PATH=/nagios/cgi-bin

## MM-DD-YY+HH:mm:ss
DOWNTIME_START="03-06-2015+04:00:00"
DOWNTIME_END="03-06-2015+08:00:00"

for host in ${HOSTS[@]}; do
    echo -n "${host}: "
    curl -s --basic -u "${NAGIOS_USERNAME}:${NAGIOS_PASSWORD}" "https://${NAGIOS_HOST}/${NAGIOS_PATH}/cmd.cgi?cmd_typ=55&cmd_mod=2&host=${host}&com_author=jvinding&com_data=rackspace+outage&trigger=0&start_time=${DOWNTIME_START}&end_time=${DOWNTIME_END}&fixed=1&childoptions=1&btnSubmit=Commit" | perl -n -e '/(?:error|info)Message.>*([^<]+)/ && print "$1\n"'
done
