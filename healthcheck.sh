#!/usr/bin/env bash

# Test SSH, port 22
echo -n "Test Squid Server"
export ERR_MSG="Error testing Squid Server"
squidclient -h ${HOSTNAME} cache_object://localhost/counters > /dev/null 2>&1 || { ret=${?}; echo " - ${ERR_MSG}, return code: ${ret}"; exit ${ret}; }
echo " Ok."

# All passed
exit 0
