#!/bin/sh

if [ $# -eq 1 ]; then
  YAML=$1
else
  YAML=${WORKSPACE}/.travis.yml
fi

LANGUAGE=`cat ${YAML} | shyaml get-value language`
if [ $LANGUAGE = "ruby" ]; then
  VERSIONS_TEMP=`cat ${YAML} | shyaml get-values rvm`
else
  VERSIONS_TEMP=`cat ${YAML} | shyaml get-values ${LANGUAGE}`
fi
