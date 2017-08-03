#!/bin/bash
#set -x

USER_NAME=‘’ #Please, specify Satellite account user name
USER_PASSWORD='' #Please, specify Satellite account passworx
CV_NAME=‘’ #Please, specify Composite Content View name for export
CV_MAIN=‘’ #Please, specify Content View name for export
CV_OPT=‘’ #Please, specify Content View name for export
CV_OPTV=‘’ #Please, specify Content View name for export
ORG_LABEL=‘’ #Please, specify Organization Label
ORG_NAME=‘’
#----------Remove a directory with old content only
cd /var/www/html/pub/katello-export/ && ls -t | tail -n+2 | xargs rm -rf

#----------Get old ID CV RedHatMain and remove----------------------------
CV_MAIN_ID=$(\
hammer \
        -u $USER_NAME -p $USER_PASSWORD \
        content-view version list \
        --content-view=$CV_MAIN --organization-label=$ORG_LABEL \
        | awk -F\| '/[0-9\.]+/ {print $1;}' \
        | sort -n -r | tail -1 \
        | tr -d ' ' \
)

hammer -u $USER_NAME -p $USER_PASSWORD content-view version delete --content-view $CV_MAIN --id=$CV_MAIN_ID

#---------------Get old ID CV RedHatOpt and remove----------------------
CV_OPT_ID=$(\
hammer \
        -u $USER_NAME -p $USER_PASSWORD \
        content-view version list \
        --content-view=$CV_OPT --organization-label=$ORG_LABEL \
        | awk -F\| '/[0-9\.]+/ {print $1;}' \
        | sort -n -r | tail -1 \
        | tr -d ' ' \
)

hammer -u $USER_NAME -p $USER_PASSWORD content-view version delete --content-view $CV_OPT --id=$CV_OPT_ID

#---------------------Get old ID CV RedHatOptV and remove--------------------------
CV_OPTV_ID=$(\
hammer \
        -u $USER_NAME -p $USER_PASSWORD \
        content-view version list \
        --content-view=$CV_OPTV --organization-label=$ORG_LABEL \
        | awk -F\| '/[0-9\.]+/ {print $1;}' \
        | sort -n -r | tail -1 \
        | tr -d ' ' \
)

hammer -u $USER_NAME -p $USER_PASSWORD content-view version delete --content-view $CV_OPTV --id=$CV_OPTV_ID

#----------Get ID CCV RHRT and remove-----------------
CV_RHRT_ID=$(\
hammer \
        -u $USER_NAME -p $USER_PASSWORD \
        content-view version list \
        --content-view=$CV_NAME --organization-label=$ORG_LABEL \
        | awk -F\| '/[0-9\.]+/ {print $1;}' \
        | sort -n -r | tail -1 \
        | tr -d ' ' \
)

hammer -u $USER_NAME -p $USER_PASSWORD content-view version delete --content-view $CV_NAME --id=$CV_RHRT_ID
