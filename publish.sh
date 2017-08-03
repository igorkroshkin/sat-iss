#!/bin/bash
#set -x

USER_NAME=‘’ #Please, specify Satellite account user name
USER_PASSWORD='' #Please, specify Satellite account passworx
CV_NAME=‘’ #Please, specify Composite Content View name for export
CV_MAIN=‘’ #Please, specify Content View name for export
CV_OPT=‘’ #Please, specify Content View name for export
CV_OPTV=‘’ #Please, specify Content View name for export
ORG_LABEL=‘’ #Please, specify Organization Label
ORG_NAME=‘’ #Please, specify Organization Name


#----------Get ID CV RedHatMain and publish----------------------------
hammer -u $USER_NAME -p $USER_PASSWORD content-view publish --name $CV_MAIN --organization-label $ORG_LABEL

CV_MAIN_ID=$(\
hammer \
        -u $USER_NAME -p $USER_PASSWORD \
        content-view version list \
        --content-view=$CV_MAIN --organization-label=$ORG_LABEL \
        | awk -F\| '/[0-9\.]+/ {print $1;}' \
        | sort -n | tail -1 \
        | tr -d ' ' \
)


#---------------Get ID CV RedHatOpt and publish----------------------
hammer -u $USER_NAME -p $USER_PASSWORD content-view publish --name $CV_OPT --organization-label $ORG_LABEL

CV_OPT_ID=$(\
hammer \
        -u $USER_NAME -p $USER_PASSWORD \
        content-view version list \
        --content-view=$CV_OPT --organization-label=$ORG_LABEL \
        | awk -F\| '/[0-9\.]+/ {print $1;}' \
        | sort -n | tail -1 \
        | tr -d ' ' \
)


#---------------------Get ID CV RedHatOptV and publish--------------------------
hammer -u $USER_NAME -p $USER_PASSWORD content-view publish --name $CV_OPTV --organization-label $ORG_LABEL

CV_OPTV_ID=$(\
hammer \
        -u $USER_NAME -p $USER_PASSWORD \
        content-view version list \
        --content-view=$CV_OPTV --organization-label=$ORG_LABEL \
        | awk -F\| '/[0-9\.]+/ {print $1;}' \
        | sort -n | tail -1 \
        | tr -d ' ' \
)
#----------Update CCV with latest ID's, and publish-----------------

sleep 30
hammer -u $USER_NAME -p $USER_PASSWORD content-view update --name=$CV_NAME --component-ids=$CV_OPTV_ID,$CV_OPT_ID,$CV_MAIN_ID --organization=$ORG_NAME
sleep 1m
hammer -u $USER_NAME -p $USER_PASSWORD content-view publish --name=$CV_NAME --organization-label $ORG_LABEL
