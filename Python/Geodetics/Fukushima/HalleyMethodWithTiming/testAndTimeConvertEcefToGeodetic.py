#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#
#  MAIN PROGRAM:
#
#    testAndTimeConvertEcefToGeodetic
# 
#-------------------------------------------------------------------------------
#
#  PURPOSE:
# 
#     To test the onversion Earth Centered Earth Fixed (ECEF)
#     rectangular coordinates to geodetic coordinates for a specified
#     reference ellipsoid.
# 
#-------------------------------------------------------------------------------
# 
#  METHOD OF CONVERSION FOR EACH ECEF X, Y, Z RECTANGULAR
#  COORDINATES TO GEODETIC COORDINATES:
# 
#     [ 1 ] Uses the economic third-order Halley's method to
#           approximate a solution for the general non-linear
#           geodetic equation numerically.
# 
#     [ 2 ] Uses only one iteration of the iterative Halley's method
#           to achieve near double precision accuracy.
# 
#     [ 3 ] Uses a technique to avoid division operations which
#           significantly accelerates the backward transformation
#           without degrading the precision.
# 
#-------------------------------------------------------------------------------
# 
#  STRATEGY FOR MEASURING CONVERION ACCURACY OF ONE SET OF
#  ECEF COORDINATES CONVERTED TO GEODETIC COORDINATES:
# 
#    [ 1 ]  Define true geodetic latitude and altitude
# `         values along the East geocentric longitude
#   `       meridian at specified longitude [degrees].
# 
#    [ 2 ]  Using the exact geodetic to ECEF rectangular
#           conversion function, generate true rectangular
#           ECEF X, Y and Z coordinate values based on the
#           specified true geodetic latitude, true geodeti
#           altitude and the specifed constant true geocentric
#           longitude value.
# 
#    [ 3 ]  Compute estimated geodetic latitude and altitude
#           values based on the true rectangular ECEF X, Y
#           and Z values.
# 
#    [ 4 ]  Report the differences between the defined true
#           geodetic latitude and altitude values and the
#           estimated geodetic latitude and altitude values.
# 
#-------------------------------------------------------------------------------
# 
#  COORDINATE CONVERSION TIMING:
# 
#  COORDINATE CONVERSION TIMING MEASUREMENTS OCCUR OVER A TRIAL
# 
#  A TRIAL OCCURS OVER A SPECIFIED TRUE GEOCENTRIC
#  LONGITUDE (ie. ON A SPECIFIED GEOCENTRIC MEDIDIAN)
# 
#  A TRIAL CONSISTS OF:
# 
#    Performing the following 32 ECEF rectangular
#    X, Y, Z coordinates to geodetic latitude and
#    altitude conversions.
# 
#      [ 1 ]  Converting ECEF rectangular X, Y, Z coordinates
#             at each 15 degrees of true geodetic latitude
#             along the specified true East longitude meridian
#             from the equator to the north pole.
# 
#      [ 2 ]  At each true geodetic latitude,
#             perform seperate geodetic coordinate conversions
#             at each of four specified true geodetic altitudes.
# 
#    Report the sum of the execution times over each of
#    the coordinate conversion function calls involved in
#    the 32 ECEF rectangular coorindates conversions to
#    geodetic coordinates.
# 
#-------------------------------------------------------------------------------
# 
#   AUTHOR(s):
# 
#     [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
#            National Astronomical Observatory of Japan (NAOJ)
#            Address:  2-21-1, Ohsawa, Mitaka, Tokyo 181-8588, Japan
#            Phone:    +81-422-34-3613
# 
#-------------------------------------------------------------------------------
# 
#   REFERENCE(s):
# 
#     [ 1 ]  "Transformation from Cartesian to geodetic
#             coordinates accelerated by Halley's method",
#            Toshio Fukushima,
#            Journal Of Geodesy (2006),
#            Volume 79,
#            Pages 689-693
# 
#     [ 2 ]  "Fast transform from geocentric to geodetic coordinates",
#            Toshio Fukushima,
#            Journal Of Geodesy (1999),
#            Volume 73,
#            Pages 603–610
# 
#     [ 3 ]  "Geometric Geodesy, Part A",
#            "A set of lecture notes which are an introduction to
#             ellipsoidal geometry related to geodesy.",
#             R. E. Deakin and M. N. Hunter,
#             School of Mathematical and Geospatial Sciences,
#             RMIT University,
#             Melbourne, Australia,
#             January 2013
#             www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
# 
#     [ 4 ]  'Various parameterizations of "latitude" equation -
#             Cartesian to geodetic coordinates transformation',
#             Marcin Ligas,
#             Journal of Geodetic Science,
#             Pages 87 - 94,
#             2013
# 
#     [ 5 ]  "In numerical analysis, Halley's method is a root-finding
#             algorithm used for functions of one real variable with a
#             continuous second derivative.",
#            "The rate of convergence of the iterative Halley's method
#             is cubic.",
#            "There exist multidimensional versions of Halley's method.",
#            wikipedia.org/wiki/Halley's_method`
# 
#{------------------------------------------------------------------------------
from enum                              import Enum;
from enum                              import IntEnum;
import math;
import time;
import os;
#-------------------------------------------------------------------------------
from decimal                           import Decimal;
from generateTestProgramPurposeMessage import generateTestProgramPurposeMessage;
from generateTestProgramOutputHeader   import generateTestProgramOutputHeader;
from executeOneTrialConvertEcefToGeodetic                                      \
                              import executeOneTrialConvertEcefToGeodetic;
#-------------------------------------------------------------------------------
class EcefToGeodeticConversionStatusEnum( IntEnum ):
      #{------------------------------------------------------------------------
         SUCCESS_STATUS                 = +1;
         UNDETERMINED_STATUS            =  0;
         INVALID_ELLIPSOIDAL_FLATTENING = -1;
         INVALID_EQUATORIAL_RADIUS      = -2;
      #}------------------------------------------------------------------------
#-------------------------------------------------------------------------------
numberOfTrials                         = 4 * 360;
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
startingEastGeocentricLongitudeDegrees =   0.0;
deltaEastGeocentricLongitudeDegrees    = 360.0 / numberOfTrials;
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
totalTrialsExecutionTimeMicroSeconds            = 0.0;
totalTrialsMaximumGeodeticNorthLatitudeAbsError = 0.0;
totalTrialsMaximumGeodeticAltitudeAbsError      = 0.0;
#-------------------------------------------------------------------------------
#
#  Generate purpose message.
#
#-------------------------------------------------------------------------------
generateTestProgramPurposeMessage(  );
#-------------------------------------------------------------------------------
#
#  Loop over all timing trials.
#
#-------------------------------------------------------------------------------
for trialIndex in range(                                                       \
                          1, ( numberOfTrials + 1 )                            \
                       ):
     #{-------------------------------------------------------------------------
        trialExecutionTimeMicroSeconds = 0.0;
     #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        specifiedFixedGeocentricTrueEastLongitudeDegrees =                     \
                 startingEastGeocentricLongitudeDegrees                        \
                 +                                                             \
                 (                                                             \
                   ( trialIndex - 1 )                                          \
                   *                                                           \
                   deltaEastGeocentricLongitudeDegrees                         \
                 );
     #--------------------------------------------------------------------------
     #  Compute coordinate conversions over the specified geocentric meridian.
     #--------------------------------------------------------------------------
        executionTimeOfTrialFunctionCallsMicroSeconds            = 0.0;
        executionTimeOfTrialFunctionCallsMicroSecondsReturnValue = 0.0;
        maximumGeodeticAltitudeAbsoluteErrorNanoMeters           = 0.0;
     #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        executeOneTrialConvertEcefToGeodeticReturnValue =                      \
        executeOneTrialConvertEcefToGeodetic                                   \
               (                                                               \
                 specifiedFixedGeocentricTrueEastLongitudeDegrees              \
               );
     #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --
        executionTimeOfTrialFunctionCallsMicroSeconds         =                \
                 executeOneTrialConvertEcefToGeodeticReturnValue[ 0 ];
        maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs =                \
                 executeOneTrialConvertEcefToGeodeticReturnValue[ 1 ];
        maximumGeodeticAltitudeAbsoluteErrorNanoMeters        =                \
                 executeOneTrialConvertEcefToGeodeticReturnValue[ 2 ];
     #--------------------------------------------------------------------------
        totalTrialsExecutionTimeMicroSeconds =                                 \
             totalTrialsExecutionTimeMicroSeconds                              \
             +                                                                 \
             executionTimeOfTrialFunctionCallsMicroSeconds;
     #--------------------------------------------------------------------------
        totalTrialsMaximumGeodeticNorthLatitudeAbsError =                      \
          max                                                                  \
           (                                                                   \
             totalTrialsMaximumGeodeticNorthLatitudeAbsError,                  \
             maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs             \
           );
        totalTrialsMaximumGeodeticAltitudeAbsError =                           \
          max                                                                  \
           (                                                                   \
             totalTrialsMaximumGeodeticAltitudeAbsError,                       \
             maximumGeodeticAltitudeAbsoluteErrorNanoMeters                    \
           );
     #--------------------------------------------------------------------------
     #  End of loop over timing trials.
     #}-------------------------------------------------------------------------
#-------------------------------------------------------------------------------
averageTrialExecutionTimeMicroSeconds =                                        \
          totalTrialsExecutionTimeMicroSeconds                                 \
          /                                                                    \
          numberOfTrials;
#------------------------------------------------------------------------------
print                                                                         \
 (
   "\n\n\n",
 );
print                                                                          \
 (
   "============================================" +
   "============================================" 
 );
print                                                                         \
 (
   "|",
   "| AVERAGE TRIAL TIMING RESULTS:",
   "|",
   sep=os.linesep
 );
print                                                                         \
 (
   "|   Average execution time over ",
   end=""
 );
print                                                                         \
 (
   "%d"  %( numberOfTrials ),
   end=""
 );
print                                                                         \
 (
   " trial(s) of"
 );
print                                                                         \
 (
   "|     'convertEcefToGeodetic' function calls:-->",
   end=""
 );
print                                                                         \
 (
   "%14.6e" %( averageTrialExecutionTimeMicroSeconds ),
   end=""
 );
print                                                                         \
 (
   " [microseconds]"
 );
print                                                                         \
 (
   "|"
 );
print                                                                          \
 (
   "============================================" +
   "============================================" 
 );
print                                                                         \
 (
   "\n\n\n",
 );
#------------------------------------------------------------------------------
print                                                                         \
 (
   "============================================" +
   "============================================" 
 );
print                                                                         \
 (
   "|",
   "|  MAXIMUM ABSOLUTE ERRORS OVER ALL TRIALS:",
   "|",
   "|    Maximum geodetic north latitude absolute error",
   sep=os.linesep
 );
print                                                                         \
 (
   "|      is:-->",
   "%+14.6f" % ( totalTrialsMaximumGeodeticNorthLatitudeAbsError ),
   end = ""
 );
print                                                                         \
 (
   " [microarcseconds]"
 );
print                                                                         \
 (
   "|",
   "|    Maximum geodetic altitude absolute error",
   sep=os.linesep
 );
print                                                                         \
 (
   "|      is:-->",
   "%+14.6f"  %( totalTrialsMaximumGeodeticAltitudeAbsError ),
   end = ""
 );
print                                                                         \
 (
   " [nanometers]"
 );
print                                                                         \
 (
   "|"
 );
print                                                                         \
 (
   "============================================" +
   "============================================"
 );
print( "\n\n\n" );
#}-----------------------------------------------------------------------------

