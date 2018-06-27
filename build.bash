#!/usr/bin/env bash
#
# Build script
# Run this script by passing in the reverse domain to use for the output package.
#
# Released under the GNU GPL v3 or later
# Copyright 2018 - Henri Shustak
# 

# running as root
if [ "`whoami`" != root ] ; then
	"     ERROR! : Run this build script as root!"
	exit -200
fi

# confirm that there is an argument passed in to be used as the reverse domain
reverse_DNS="${1}"
if [ "${reverse_DNS}" == "" ] ; then
	echo ""
	echo " Usage example : ./build.bash <com.reversedomain>"
	echo ""
	echo "    Usage note : Use your insitutions reverse domain indentifier"
	echo "                 in place of : <com.reversedomain>"
	echo ""
	exit -3
fi

# make sure we can locate the parent directory
parent_directory="`dirname \"${0}\"`" ; if [ "`echo "${parent_directory}" | grep -e "^/"`" == "" ] ; then parent_directory="`pwd`/${parent_directory}" ; fi
cd "${parent_directory}"
if [ ${?} != 0 ] ; then 
	echo "     ERROR! switching to build script parent directory : ${parent_directory}"
	exit -2 ; 
fi

#check luggage is installed on this system
if ! [ -e "/usr/local/share/luggage/luggage.make" ] ; then
	echo "     ERROR! luggage not installed on this system "
	echo "            pick up a copy today : http://github.com/unixorn/luggage"
	exit -1
fi

# use the template to create the daemon plist file
daemon_plist_template_file="template.linewize-logout.plist"
daemon_plist_template_name="${reverse_DNS}.linewize-logout.plist"
sed s/XXXXXXXXXXXXXXXXXXX/${reverse_DNS}/g "./${daemon_plist_template_file}" > "./${daemon_plist_template_name}"


# use the template to create the postflight file
postflight_template_file="template.postflight"
sed s/XXXXXXXXXXXXXXXXXXX/${reverse_DNS}/g "./${postflight_template_file}" > "./postflight"
chmod 755 ./postflight

# use the template to create the
makefile_template_file="template.Makefile"
sed s/XXXXXXXXXXXXXXXXXXX/${reverse_DNS}/g "./${makefile_template_file}" > "./Makefile"

# use the luggage to build the output file.
make pkg
exit_value=${?}

# clean up the build files and move
rm -rf "./postflight"
rm -rf "./${daemon_plist_template_name}"
rm -rf "./Makefile"

exit ${exit_value}



