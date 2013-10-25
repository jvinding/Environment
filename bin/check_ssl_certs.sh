#!/bin/sh

for CERT in biz.closely.com:443 api.closely.com:443; do
    echo checking ${CERT}...
    echo | openssl s_client -connect ${CERT} 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | openssl x509 -noout -subject -dates
    echo
done
