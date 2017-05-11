#!/bin/bash -x
#
# insights_get_playbook.sh
#
# This script can be used to download an Ansible playbook from the
# Red Hat Insights service and upload it to a github repository.
# 
# For now, it queries the Insights service for ${GROUP} and then
# looks at each system's reports. It adds reports that have 
# ansible playbooks to a maintenance plan named
# ${GROUP}-${DATE:TIME} and then downloads one giant playbook.
# 
# Author: jlabocki@redhat.com
# Date:   05.11.17
#

### SETTINGS
#Uncomment this line and put your customer portal credentials here
#CREDS="username:password"

#Set this to the group you want to download all playbooks for
GROUP="labs-console"

### SCRIPT
if ! type "jq" > /dev/null; then
 echo "  jq not found!"
 echo "  You'll need to install jq for this to work"
 echo "  You can get it at https://stedolan.github.io/jq/" 
 echo "  Then include it in your path via `export PATH=${PATH}:/your/path`"
 exit 1
fi

#Create a new maintenance plan
REQUEST_BODY=$(< <(cat <<EOF
{
  "name": "$GROUP"
}
EOF
))
MAINT_PLAN=`curl -s -u ${CREDS} -X POST -H "Content-Type: application/json" -d "$REQUEST_BODY" https://access.redhat.com/r/insights/v1/maintenance |awk -F":" '{print $2}' |awk -F"}" '{print $1}'`

#Get Group ID of group named "${GROUP}"
# If you have a way of using an ID, it's better, but we will use a name for now unless you can get it from the tower job
# that provisions the openshift cluster.
ID=`curl -s -u ${CREDS} -X GET https://access.redhat.com/r/insights/v1/groups | jq --arg THEGROUP $GROUP -r '.[] | select(.display_name == $THEGROUP ) | {id}'`
SHORT_ID=`echo ${ID} |awk -F" " '{print $3}'`

# Get list of system IDs in group
### The command to get just system_ids
SYSTEM_IDS=`curl -s -u ${CREDS} -X GET https://access.redhat.com/r/insights/v1/groups/${SHORT_ID}?include=systems | jq -r '.systems | .[] | .system_id'`

for SYSTEM in ${SYSTEM_IDS}; do
 REPORT_ID=`curl -s -u ${CREDS} -X GET https://access.redhat.com/r/insights/v1/systems/${SYSTEM}/reports | jq '.reports | .[]| .id'`
 REPORT_ID_LIST=`echo ${REPORT_ID_LIST} ${REPORT_ID}`
done

REPORT_ID_LIST=`echo ${REPORT_ID_LIST} | tr '[[:blank:]]/ ' ','`

#Add reports to maintenance plan
REQUEST_BODY=$(< <(cat <<EOF
{
  "name": "$GROUP",
  "reports": [$REPORT_ID_LIST]
}
EOF
))

curl -s -u ${CREDS} -X PUT -H "Content-Type: application/json" -d "$REQUEST_BODY" https://access.redhat.com/r/insights/v1/maintenance/${MAINT_PLAN}

#Save the ansible playbook
curl -s -u ${CREDS} -X GET https://access.redhat.com/r/insights/v3/maintenance/${MAINT_PLAN}/playbook > playbook.yaml

exit 0


