#!/bin/bash

apt-get -y install subversion gfortran xutils-dev libxt-dev libxft-dev \
    libmotif-dev libxpm-dev libxext-dev \
    expect libgl1-mesa-dev libmysqlclient-dev tcsh libbz2-dev scons \
    libxml-simple-perl libxml-writer-perl libfile-slurp-perl git cmake \
    python-dev libglu1-mesa-dev

cd /usr/bin; ln -s make gmake

cd /usr/include # for cernlib
for file in ft2build.h config freetype.h fttypes.h ftsystem.h ftimage.h \
    fterrors.h ftmoderr.h fterrdef.h
do
    ln -s freetype2/$file .
done

cd /usr/include/freetype2 ; ln -s ../freetype2 freetype # for ROOT

cd /home/bobby/Settingup-master/Relevant_GLUEX

pushd gluex_top

pwd_string=`pwd`
export GLUEX_TOP=$pwd_string
export BUILD_SCRIPTS=$GLUEX_TOP/build_scripts
rm -fv setup.sh
echo export GLUEX_TOP=$pwd_string > setup.sh
echo export BUILD_SCRIPTS=\$GLUEX_TOP/build_scripts >> setup.sh
echo source \$BUILD_SCRIPTS/gluex_env_version.sh $pwd_string/version.xml >> setup.sh
rm -fv setup.csh
echo setenv GLUEX_TOP $pwd_string > setup.csh
echo setenv BUILD_SCRIPTS \$GLUEX_TOP/build_scripts >> setup.csh
echo source \$BUILD_SCRIPTS/gluex_env_version.csh $pwd_string/version.xml >> setup.csh
if [ -f version.xml ]
    then
    echo version.xml exists, skip download
else
    echo getting version.xml from halldweb.jlab.org
    wget --no-check-certificate https://halldweb.jlab.org/dist/version.xml
fi
source $BUILD_SCRIPTS/gluex_env_version.sh
make -f $BUILD_SCRIPTS/Makefile_all gluex
popd
