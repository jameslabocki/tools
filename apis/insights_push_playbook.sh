#!/bin/bash
#
# insights_push_playbook.sh
#
# This script can be used to push a playbook to a git repository
# 
# Author: jlabocki@redhat.com
# Date:   05.11.17
#

### Settings
#Set this to the git repository you'd like to drop playbooks into
#You'll need to have ssh key auth working on the system or else it will fail
GITURL="https://github.com/strategicdesignteam/insights-playbooks.git"
GITREPONAME="insights-playbooks"

#Github username
#GITUSER="youruser"

#Playbook that you want to add
PLAYBOOK="playbook.yaml"

echo "cloning ${GITURL}"
git clone ${GITURL}

echo "changing directory to ${GITREPONAME}"
cd ${GITREPONAME}

echo "copying ${PLAYBOOK} to ${GITREPONAME}"
cp -f ../${PLAYBOOK} ./

echo "adding ${PLAYBOOK}"
git add ${PLAYBOOK}

echo "committing"
TIMESTAMP=`date`
git commit -m "Automatic commit from insights_push_playbook at ${TIMESTAMP}"

echo "pushing"
git push 
