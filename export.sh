#!/bin/bash
#set -x

USER_NAME=‘’ #Please, specify Satellite account user name
USER_PASSWORD=‘’ #Please, specify Satellite account passworx
CV_NAME=‘’ #Please, specify Composite Content View name for export
ORG_LABEL=‘’ #Please, specify Organization Label
KATELLO_EXPORT=/var/www/html/pub/katello-export #Please, specify katello-export directory
EXPORT_SYMLINK=/var/www/html/pub/export-latest #Please, specify sym link locationw, which acts a sync point for Downstream Satellite.

# Get CV Version
CV_VERSION=$(\
hammer \
        -u $USER_NAME -p $USER_PASSWORD \
        content-view version list \
        --content-view=$CV_NAME --organization-label=$ORG_LABEL \
        | awk -F\| '/[0-9\.]+/ {print $3;}' \
        | sort -n | tail -1 \
        | tr -d ' ' \
)

# Export CV ID
hammer -u $USER_NAME -p $USER_PASSWORD \
        content-view version export \
        --organization-label=$ORG_LABEL --content-view=$CV_NAME --version=$CV_VERSION

# Create and change symbolic link
EXPORT_LATEST=$KATELLO_EXPORT/$ORG_LABEL-$CV_NAME-v$CV_VERSION/$ORG_LABEL/content_views/$CV_NAME/$CV_VERSION/
if [ -L "$EXPORT_SYMLINK" ]; then
    rm -f "$EXPORT_SYMLINK"
fi
ln -s $EXPORT_LATEST $EXPORT_SYMLINK
