#!/bin/sh
echo "fix-permissions: Changing permissions for:"
for folder in `ls -d $@`; do
	echo "		${folder}"
 	chgrp -R 0 ${folder} && chmod -R g=u ${folder}	
done 