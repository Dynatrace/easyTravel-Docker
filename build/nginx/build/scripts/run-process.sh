#!/bin/bash
ET_FRONTEND_LOCATION=${ET_FRONTEND_LOCATION:-"localhost:8080"}

wait-for-cmd.sh "nc -z `echo ${ET_FRONTEND_LOCATION} | sed 's/:/ /'`" 360

# Replace the upstream server location template variable with the actual value.
echo "Waiting for the easyTravel Customer Frontend on ${ET_FRONTEND_LOCATION}"
sed -i -e "s/\${ET_FRONTEND_LOCATION}/${ET_FRONTEND_LOCATION}/" /etc/nginx/nginx.conf

nginx -g "daemon off;"