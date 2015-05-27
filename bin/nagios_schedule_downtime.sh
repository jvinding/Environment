#!/bin/bash -eu

if [ -z "${NAGIOS_USERNAME:-}" ] || [ -z "${NAGIOS_PASSWORD:-}" ]; then
    echo "NAGIOS_USERNAME and NAGIOS_PASSWORD must be set"
    exit 1
fi

usage() {
    echo
    echo "Schedules of downtime for the hosts passed in on the command line"
    echo "Usage: $0 [-l <time>] <hostname 1>[..<hostname N>]"
    echo "    -l: length of downtime, e.g. '90M' or '12H' (default: 90M)"
    echo
}

LENGTH=90M

if [ 0 != $# ] && [ "-l" == "$1" ]; then
    if [ $# -ge 2 ] && [[ "$2" =~ ^[0-9]+[MHD]$ ]]; then
        LENGTH=$2
        shift
        shift
    else
        echo "Invalid length paramteter" >&2
        usage
        exit 1
    fi
fi

if [ 0 == $# ]; then
    echo "At least 1 host must be passed on the command line" >&2
    usage
    exit 1
fi

HOSTS=("$@")

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
DOWNTIME_END=$(date -u -v +${LENGTH} +%m-%d-%Y+%H:%M:%S)

for host in ${HOSTS[@]}; do
    echo -n "${host}: "
    curl -s --basic -u "${NAGIOS_USERNAME}:${NAGIOS_PASSWORD}" "https://${NAGIOS_HOST}/${NAGIOS_PATH}/cmd.cgi?cmd_typ=55&cmd_mod=2&host=${host}&com_author=jvinding&com_data=outage&trigger=0&start_time=${DOWNTIME_START}&end_time=${DOWNTIME_END}&fixed=1&childoptions=1&btnSubmit=Commit" | perl -n -e '/(?:error|info)Message.>*([^<]+)/ && print "$1\n"'
done
