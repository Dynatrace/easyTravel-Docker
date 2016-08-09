#!/bin/bash
ET_BACKEND_LOCATION=${ET_BACKEND_LOCATION:-'localhost:8080'}
ET_FRONTEND_LOCATION=${ET_FRONTEND_LOCATION:-'localhost:8080'}

# Replace the upstream server location template variables with the actual values.
sed -i -e "s,\$ET_BACKEND_LOCATION,${ET_BACKEND_LOCATION}," /etc/nginx/nginx.conf
sed -i -e "s,\$ET_FRONTEND_LOCATION,${ET_FRONTEND_LOCATION}," /etc/nginx/nginx.conf

echo "Waiting for the easyTravel Business Backend on ${ET_BACKEND_LOCATION}"
wait-for-cmd.sh "nc -z `echo ${ET_BACKEND_LOCATION} | sed 's/:/ /'`" 360

echo "Waiting for the easyTravel Customer Frontend on ${ET_FRONTEND_LOCATION}"
wait-for-cmd.sh "nc -z `echo ${ET_FRONTEND_LOCATION} | sed 's/:/ /'`" 360

. /etc/default/nginx && nginx -g 'daemon off;'