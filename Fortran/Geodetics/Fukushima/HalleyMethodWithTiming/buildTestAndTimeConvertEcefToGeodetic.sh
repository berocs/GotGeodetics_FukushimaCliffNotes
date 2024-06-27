#!/bin/bash
#==============================================================================
#       1         2         3         4         5         6         7         8
#234567801234567890123456789012345678901234567890123456789012345678901234567890
#==============================================================================
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
  /bin/rm -f ./*.o ./testAndTimeConvertEcefToGeodetic.exe                      \
                                                       2>&1 | /dev/null
#-------------------------------------------------------------------------------
  FORTRAN_COMPILER="/usr/bin/gfortran"
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./convertEcefToGeodetic.o                            \
                         ./convertEcefToGeodetic.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./generateTestProgramPurposeMessage.o                \
                         ./generateTestProgramPurposeMessage.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./generateTestProgramOutputHeader.o                  \
                         ./generateTestProgramOutputHeader.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./generateConvertGeodeticToEcefPurposeMessage.o      \
                         ./generateConvertGeodeticToEcefPurposeMessage.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./generateConvertGeodeticToEcefUsageMessage.o        \
                         ./generateConvertGeodeticToEcefUsageMessage.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./generateConvertEcefToGeodeticPurposeMessage.o      \
                         ./generateConvertEcefToGeodeticPurposeMessage.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./generateConvertEcefToGeodeticUsageMessage.o        \
                         ./generateConvertEcefToGeodeticUsageMessage.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./convertGeodeticToEcef.o                            \
                         ./convertGeodeticToEcef.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./testAndTimeConvertEcefToGeodeticMainProgram.o      \
                         ./testAndTimeConvertEcefToGeodeticMainProgram.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -c                                                      \
                      -o ./executeOneTrialConvertEcefToGeodetic.o             \
                         ./executeOneTrialConvertEcefToGeodetic.f
#------------------------------------------------------------------------------
  ${FORTRAN_COMPILER}                                                         \
                      -g                                                      \
                      -o ./testAndTimeConvertEcefToGeodetic.exe               \
                         ./generateTestProgramPurposeMessage.o                \
                         ./generateTestProgramOutputHeader.o                  \
                         ./generateConvertGeodeticToEcefPurposeMessage.o      \
                         ./generateConvertGeodeticToEcefUsageMessage.o        \
                         ./generateConvertEcefToGeodeticPurposeMessage.o      \
                         ./generateConvertEcefToGeodeticUsageMessage.o        \
                         ./convertGeodeticToEcef.o                            \
                         ./convertEcefToGeodetic.o                            \
                         ./executeOneTrialConvertEcefToGeodetic.o             \
                         ./testAndTimeConvertEcefToGeodeticMainProgram.o
#-------------------------------------------------------------------------------
  /bin/rm -f ./*.o 2>&1 | /dev/null
#-------------------------------------------------------------------------------
  echo ""
  echo "------------------------------------------------------------------"
  echo "|"
  echo "| Finished building Geodetic Conversion program."
  echo "|"
  echo "|    Program is:-->'./testAndTimeConvertEcefToGeodetic'"
  echo "|"
  echo "------------------------------------------------------------------"
  echo ""
  echo ""
  echo ""
#==============================================================================

