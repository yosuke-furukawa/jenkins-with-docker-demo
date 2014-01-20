#!/bin/sh

BEFORE_SCRIPT=`cat ${WORKSPACE}/.travis.yml | shyaml get-values before_script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
TEST_SCRIPT=`cat ${WORKSPACE}/.travis.yml | shyaml get-values script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
AFTER_SCRIPT=`cat ${WORKSPACE}/.travis.yml | shyaml get-values after_script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
BEFORE_INSTALL=`cat ${WORKSPACE}/.travis.yml | shyaml get-values before_script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`

case ${LANGUAGE} in
  node_js)
    DEFAULT_INSTALL_SCRIPT='npm install'
    DEFAULT_TEST_SCRIPT='npm test'
    TEST_SCRIPT=${TEST_SCRIPT:-${DEFAULT_TEST_SCRIPT}}
    SCRIPT="
    export PATH=/home/worker/.nodebrew/current/bin:$PATH\\n
    nodebrew use ${VERSION}\\n
    ${BEFORE_INSTALL}\\n
    ${DEFAULT_INSTALL_SCRIPT}\\n
    ${BEFORE_SCRIPT}\\n
    ${TEST_SCRIPT}\\n
    ${AFTER_SCRIPT}\\n
    "
    ;;
  ruby)
    DEFAULT_INSTALL_SCRIPT='bundle install'
    DEFAULT_TEST_SCRIPT='rake'
    TEST_SCRIPT=${TEST_SCRIPT:-${DEFAULT_TEST_SCRIPT}}
    SCRIPT="
    source /home/worker/.rvm/scripts/rvm\\n
    rvm use ${VERSION}\\n
    ${BEFORE_INSTALL}\\n
    ${DEFAULT_INSTALL_SCRIPT}\\n
    ${BEFORE_SCRIPT}\\n
    ${TEST_SCRIPT}\\n
    ${AFTER_SCRIPT}\\n
    "
    ;;
  perl)
    DEFAULT_INSTALL_SCRIPT='cpanm --installdeps --notest .'
    TEST_SCRIPT=${TEST_SCRIPT:-${DEFAULT_TEST_SCRIPT}}
    if [ -e ${WORKSPACE}/Build.PL ]; then
      DEFAULT_TEST_SCRIPT='perl Build.PL && ./Build test'
    elif [ -e ${WORKSPACE}/Makefile.PL ]; then
      DEFAULT_TEST_SCRIPT='perl Makefile.PL && make test'
    elif [ -e ${WORKSPACE}/Build.pl ]; then
      DEFAULT_TEST_SCRIPT='perl Build.pl && ./Build test'
    elif [ -e ${WORKSPACE}/Makefile.pl ]; then
      DEFAULT_TEST_SCRIPT='perl Makefile.pl && make test'
    else
      DEFAULT_TEST_SCRIPT='make test'
    fi
    SCRIPT="
    source /home/worker/perlbrew/etc/bashrc\\n
    perlbrew use ${VERSION}\\n
    ${BEFORE_INSTALL}\\n
    ${DEFAULT_INSTALL_SCRIPT}\\n
    ${BEFORE_SCRIPT}\\n
    ${TEST_SCRIPT}\\n
    ${AFTER_SCRIPT}\\n
    "
    ;;
esac
