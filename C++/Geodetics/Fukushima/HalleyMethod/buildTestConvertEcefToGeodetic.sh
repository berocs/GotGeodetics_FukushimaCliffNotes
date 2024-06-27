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
  /bin/rm -f ./*.o ./testConvertEcefToGeodetic.exe |& /dev/null
#-------------------------------------------------------------------------------
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -c                                                                       \
      -o ./generateTestProgramOutputHeader.o                                   \
         ./generateTestProgramOutputHeader.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -c                                                                       \
      -o ./generateTestProgramPurposeMessage.o                                 \
         ./generateTestProgramPurposeMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -c                                                                       \
      -o ./generateConvertEcefToGeodeticPurposeMessage.o                       \
         ./generateConvertEcefToGeodeticPurposeMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -c                                                                       \
      -o ./generateConvertEcefToGeodeticUsageMessage.o                         \
         ./generateConvertEcefToGeodeticUsageMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -c                                                                       \
      -o ./generateConvertGeodeticToEcefPurposeMessage.o                       \
         ./generateConvertGeodeticToEcefPurposeMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -c                                                                       \
      -o ./generateConvertGeodeticToEcefUsageMessage.o                         \
         ./generateConvertGeodeticToEcefUsageMessage.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -c                                                                       \
      -o ./convertEcefToGeodetic.o                                             \
         ./convertEcefToGeodetic.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -c                                                                       \
      -o ./convertGeodeticToEcef.o                                             \
         ./convertGeodeticToEcef.cpp
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -c                                                                       \
      -o ./testConvertEcefToGeodetic.o                                         \
         ./testConvertEcefToGeodetic.cpp
#-------------------------------------------------------------------------------
  g++                                                                          \
      -I .                                                                     \
      -g                                                                       \
      -o ./testConvertEcefToGeodetic                                           \
         ./testConvertEcefToGeodetic.o                                         \
         ./generateTestProgramOutputHeader.o                                   \
         ./generateTestProgramPurposeMessage.o                                 \
         ./generateConvertEcefToGeodeticPurposeMessage.o                       \
         ./generateConvertEcefToGeodeticUsageMessage.o                         \
         ./generateConvertGeodeticToEcefPurposeMessage.o                       \
         ./generateConvertGeodeticToEcefUsageMessage.o                         \
         ./convertEcefToGeodetic.o                                             \
         ./convertGeodeticToEcef.o
#-------------------------------------------------------------------------------
  /bin/rm -f ./*.o |& /dev/null
#-------------------------------------------------------------------------------
  echo ""
  echo "------------------------------------------------------------------"
  echo "|"
  echo "| Finished building Geodetic Conversion program."
  echo "|"
  echo "|    Program is:-->'./testConvertEcefToGeodetic'"
  echo "|"
  echo "------------------------------------------------------------------"
  echo ""
  echo ""
  echo ""
#===============================================================================
