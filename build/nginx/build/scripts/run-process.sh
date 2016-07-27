#!/bin/bash
if [ -n "${ET_FRONTEND_LOCATION}" ]; then
  echo "Waiting for the easyTravel Customer Frontend on ${ET_FRONTEND_LOCATION}"
  wait-for-cmd.sh "nc -z `echo ${ET_FRONTEND_LOCATION} | sed 's/:/ /'`" 360

  # Replace the upstream server location template variable with the actual value.
  sed -i -e "s,\$ET_FRONTEND_LOCATION,${ET_FRONTEND_LOCATION}," /etc/nginx/nginx.conf
fi

if [ -n "${ET_BACKEND_LOCATION}" ]; then
  echo "Waiting for the easyTravel Business Backend on ${ET_BACKEND_LOCATION}"
  wait-for-cmd.sh "nc -z `echo ${ET_BACKEND_LOCATION} | sed 's/:/ /'`" 360

  # Replace the upstream server location template variable with the actual value.
  sed -i -e "s,\$ET_BACKEND_LOCATION,${ET_BACKEND_LOCATION}," /etc/nginx/nginx.conf
fi

nginx -g 'daemon off;'