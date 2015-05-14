#!/bin/bash -eu

## HOSTS=(api-production3 api-production4 api-qa1 api-staging1 api-staging2 bucket1 crawl-prod1 crawl-qa1 crawl-staging1 db-production db-production1 db-qa1 db-staging1 db-staging2 logstash metadata-db metadata-production metadata-qa metadata-staging redis-prod1)
HOSTS=("$@")

if [ -z "${NAGIOS_USERNAME:-}" ] || [ -z "${NAGIOS_PASSWORD:-}" ]; then
    echo "NAGIOS_USERNAME and NAGIOS_PASSWORD must be set"
    exit 1
fi

if [ 0 == $# ]; then
    echo
    echo "At least 1 host must be passed on the command line" >&2
    echo
    echo "Schedules 30 minutes of down time for the hosts passed in on the command line"
    echo "Usage: $0 <hostname 1>[..<hostname N>]"
fi

NAGIOS_HOST=admin.closely.com
NAGIOS_PATH=/nagios/cgi-bin

## now
## date +%m-%d-%Y+%H:%M:%S
## now + 20 minutes on mac
## date -v +20M +%m-%d-%Y+%H:%M:%S
## now + 20 minutes on linux
## date -d "@$(($(date +%s) + 1200))" '+%m-%d-%Y+%H:%M:%S'
## MM-DD-YY+HH:mm:ss
DOWNTIME_START=$(date -u +%m-%d-%Y+%H:%M:%S)
DOWNTIME_END=$(date -u -v +90M +%m-%d-%Y+%H:%M:%S)

for host in ${HOSTS[@]}; do
    echo -n "${host}: "
    curl -s --basic -u "${NAGIOS_USERNAME}:${NAGIOS_PASSWORD}" "https://${NAGIOS_HOST}/${NAGIOS_PATH}/cmd.cgi?cmd_typ=55&cmd_mod=2&host=${host}&com_author=jvinding&com_data=outage&trigger=0&start_time=${DOWNTIME_START}&end_time=${DOWNTIME_END}&fixed=1&childoptions=1&btnSubmit=Commit" | perl -n -e '/(?:error|info)Message.>*([^<]+)/ && print "$1\n"'
done
