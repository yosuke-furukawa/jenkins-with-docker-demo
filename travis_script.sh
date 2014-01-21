#!/bin/sh

BEFORE_INSTALL=`cat ${WORKSPACE}/.travis.yml | shyaml get-values before_install 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
INSTALL_SCRIPT=`cat ${WORKSPACE}/.travis.yml | shyaml get-values install 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
BEFORE_SCRIPT=`cat ${WORKSPACE}/.travis.yml | shyaml get-values before_script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
TEST_SCRIPT=`cat ${WORKSPACE}/.travis.yml | shyaml get-values script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
AFTER_SCRIPT=`cat ${WORKSPACE}/.travis.yml | shyaml get-values after_script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`

case ${LANGUAGE} in
  node_js)
    DEFAULT_INSTALL_SCRIPT='npm install'
    DEFAULT_TEST_SCRIPT='npm test'
    VERSION_SCRIPT="nodebrew use ${VERSION}"
    ;;
  ruby)
    DEFAULT_INSTALL_SCRIPT='bundle install'
    DEFAULT_TEST_SCRIPT='rake'
    VERSION_SCRIPT="rvm use ${VERSION}"
    ;;
  perl)
    DEFAULT_INSTALL_SCRIPT='cpanm --installdeps --notest .'
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
    VERSION_SCRIPT="@perlbrew use ${VERSION}"
    ;;
esac


INSTALL_SCRIPT=${INSTALL_SCRIPT:-${DEFAULT_INSTALL_SCRIPT}}
TEST_SCRIPT=${TEST_SCRIPT:-${DEFAULT_TEST_SCRIPT}}
