#!/bin/bash
#===============================================================================
  echo ""
  echo ""
  echo ""
  echo "------------------------------------------------------------------"
  echo "|"
  echo "| Building Geodetic Conversion program."
  echo "|"
  echo "------------------------------------------------------------------"
  echo ""
#-------------------------------------------------------------------------------
  /bin/rm -f ./*.o ./testAndTimeConvertEcefToGeodetic.exe 2>&1 | /dev/null
#-------------------------------------------------------------------------------
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./generateTestProgramOutputHeader.o                                   \
         ./generateTestProgramOutputHeader.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./generateTestProgramPurposeMessage.o                                 \
         ./generateTestProgramPurposeMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./generateConvertEcefToGeodeticPurposeMessage.o                       \
         ./generateConvertEcefToGeodeticPurposeMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./generateConvertGeodeticToEcefPurposeMessage.o                       \
         ./generateConvertGeodeticToEcefPurposeMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./generateConvertEcefToGeodeticUsageMessage.o                         \
         ./generateConvertEcefToGeodeticUsageMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./generateConvertGeodeticToEcefUsageMessage.o                         \
         ./generateConvertGeodeticToEcefUsageMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./convertEcefToGeodetic.o                                             \
         ./convertEcefToGeodetic.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./convertGeodeticToEcef.o                                             \
         ./convertGeodeticToEcef.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./executeOneTrialConvertEcefToGeodetic.o                              \
         ./executeOneTrialConvertEcefToGeodetic.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -c                                                                       \
      -o ./testAndTimeConvertEcefToGeodeticMainProgram.o                       \
         ./testAndTimeConvertEcefToGeodeticMainProgram.cpp
#-------------------------------------------------------------------------------
  g++                                                                          \
      -I .                                                                     \
      -O2                                                                      \
      -o ./testAndTimeConvertEcefToGeodetic                                    \
         ./testAndTimeConvertEcefToGeodeticMainProgram.o                       \
         ./generateTestProgramOutputHeader.o                                   \
         ./generateTestProgramPurposeMessage.o                                 \
         ./generateConvertEcefToGeodeticPurposeMessage.o                       \
         ./generateConvertEcefToGeodeticUsageMessage.o                         \
         ./generateConvertGeodeticToEcefPurposeMessage.o                       \
         ./generateConvertGeodeticToEcefUsageMessage.o                         \
         ./convertEcefToGeodetic.o                                             \
         ./convertGeodeticToEcef.o                                             \
         ./executeOneTrialConvertEcefToGeodetic.o
#-------------------------------------------------------------------------------
  /bin/rm -f ./*.o 2>&1 | /dev/null
#-------------------------------------------------------------------------------
  echo ""
  echo "------------------------------------------------------------------"
  echo "|"
  echo "| Finished building Geodetic Conversion program."
  echo "|"
  echo "|    Program is:-->'./testAndTimeConvertEcefToGeodetic.exe'"
  echo "|"
  echo "------------------------------------------------------------------"
  echo ""
  echo ""
  echo ""
#===============================================================================
