#!/bin/bash

ET_FRONTEND_LOCATION_DEFAULT='localhost:8080'
ET_ANGULAR_FRONTEND_LOCATION_DEFAULT='localhost:9079'

ET_BACKEND_LOCATION=${ET_BACKEND_LOCATION:-'localhost:8080'}
ET_FRONTEND_LOCATION=${ET_FRONTEND_LOCATION:-$ET_FRONTEND_LOCATION_DEFAULT}
ET_ANGULAR_FRONTEND_LOCATION=${ET_ANGULAR_FRONTEND_LOCATION:-$ET_ANGULAR_FRONTEND_LOCATION_DEFAULT}

# Replace the upstream server location template variables with the actual values.
sed -i -e "s,\$ET_BACKEND_LOCATION,${ET_BACKEND_LOCATION}," /etc/nginx/nginx.conf
sed -i -e "s,\$ET_FRONTEND_LOCATION,${ET_FRONTEND_LOCATION}," /etc/nginx/nginx.conf
sed -i -e "s,\$ET_ANGULAR_FRONTEND_LOCATION,${ET_ANGULAR_FRONTEND_LOCATION}," /etc/nginx/nginx.conf

echo "Waiting for the easyTravel Business Backend on ${ET_BACKEND_LOCATION}"
wait-for-cmd.sh "nc -z `echo ${ET_BACKEND_LOCATION} | sed 's/:/ /'`" 360

if [[ "$ET_FRONTEND_LOCATION" != "$ET_FRONTEND_LOCATION_DEFAULT" ]]; then
    echo "Waiting for the easyTravel Customer Frontend on ${ET_FRONTEND_LOCATION}"
    wait-for-cmd.sh "nc -z `echo ${ET_FRONTEND_LOCATION} | sed 's/:/ /'`" 360
fi

if [[ "$ET_ANGULAR_FRONTEND_LOCATION" != "$ET_ANGULAR_FRONTEND_LOCATION_DEFAULT" ]]; then
    echo "Waiting for the easyTravel Angular Customer Frontend on ${ET_ANGULAR_FRONTEND_LOCATION}"
    wait-for-cmd.sh "nc -z `echo ${ET_ANGULAR_FRONTEND_LOCATION} | sed 's/:/ /'`" 360
fi

. /etc/default/nginx && nginx -g 'daemon off;'
