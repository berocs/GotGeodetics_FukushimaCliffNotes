def                                                                            \
executeOneTrialConvertEcefToGeodetic                                           \
       (                                                                       \
         specifiedFixedTrueGeocentricEastLongitudeDegrees                      \
       ):
#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# 
#  FUNCTION:
# 
#    executeOneTrialConvertEcefToGeodetic
# 
#-------------------------------------------------------------------------------
# 
#  PURPOSE:
# 
#    To perform one trial of converting Earth-Center Earth-Fixed (ECEF)
#    retangular coordinates to geodetic coordinates for a specified
#    reference ellipsoid.
# 
#-------------------------------------------------------------------------------
# 
#  INPUT(s):
#
#    specifiedFixedTrueGeocentricEastLongitudeDegrees
#      The specified true geocentric East longitude to be used for
#      the current trial.
#      UNIT(s):  [degrees]
#
#|------------------------------------------------------------------------------
#|
#| OUTPUT(s):
#|
#|    None
#|
#|------------------------------------------------------------------------------
#|
#| RETURN VALUE(s):
#|
#|   This function will return a vector of length three containing:
#|
#|     [ 1 ] The sum of the execution times for each of the
#|           'convertEcefToGeodetic' function calls involved in the
#|           current trail.
#|           UNIT(s):  [microseconds]
#|
#|     [ 2 ] The maximum geodetic north latitude absolute error over all
#|           'convertEcefToGeodetic' function calls in the current
#|           timing trial.
#|           UNIT(s):  [microarcseconds]
#|
#|     [ 3 ] The maximum geodetic altitude absolute error over all
#|           'convertEcefToGeodetic' function calls in the current
#|            timing trial.
#|            UNIT(s):  [nanometers]
#|
#|------------------------------------------------------------------------------
#|
#| A TRIAL CONSISTS OF:
#|
#|   [ 1 ]  Performing the following 32 conversions.
#|
#|   [ 2 ]  Converting ECEF rectangular coordinates at each 15
#|          degrees of geodetic latitude along the specified
#|          geocentric longitude meridian from the equator
#|          to the north pole.
#|
#|   [ 3 ]  At each latitude, perform the conversion at four
#|          different geodetic altitudes.
#|
#|------------------------------------------------------------------------------
#|
#|  METHOD OF EACH ECEF TO GEODETIC CONVERSION:
#|
#|   [ 1 ]  Uses the economic third-order Halley's method to
#|          approximate a solution for the general non-linear
#|          geodetic equation numerically.
#|
#|   [ 2 ]  Uses only one iteration of the iterative Halley's
#|          method to achieve near double precision accuracy.
#|
#|   [ 3 ]  Uses a technique to avoid division operations which
#|          significantly accelerates the backward transformation
#|          without degrading the precision.
#|
#|   [ 4 ]  Report the differences between the defined true
#|          geodetic values and the estimated geodetic
#|          values.
#|
#|------------------------------------------------------------------------------
#|
#|  AUTHOR(s):
#|
#|   [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
#|          National Astronomical Observatory of Japan (NAOJ)
#|          Address:  2-21-1, Ohsawa, Mitaka, Tokyo 181-8588, Japan
#|          Phone:    +81-422-34-3613
#|
#|------------------------------------------------------------------------------
#|
#|  REFERENCE(s):
#|
#|   [ 1 ]  "Transformation from Cartesian to geodetic
#|           coordinates accelerated by Halley''s method",
#|          Toshio Fukushima,
#|          Journal Of Geodesy (2006),
#|          Volume 79,
#|          Pages 689-693
#|
#|   [ 2 ]  "Fast transform from geocentric to geodetic coordinates",
#|          Toshio Fukushima,
#|          Journal Of Geodesy (1999),
#|          Volume 73,
#|          Pages 603–610
#|
#|   [ 3 ]  "Geometric Geodesy, Part A",
#|          "A set of lecture notes which are an introduction to
#|           ellipsoidal geometry related to geodesy.",
#|           R. E. Deakin and M. N. Hunter,
#|           School of Mathematical and Geospatial Sciences,
#|           RMIT University,
#|           Melbourne, Australia,
#|           January 2013
#|           www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
#|
#|   [ 4 ]  'Various parameterizations of "latitude" equation -
#|           Cartesian to geodetic coordinates transformation',
#|           Marcin Ligas,
#|           Journal of Geodetic Science,
#|           Pages 87 - 94,
#|           2013
#|
#|   [ 5 ]  "In numerical analysis, Halley's method is a root-finding
#|           algorithm used for functions of one real variable with a
#|           continuous second derivative.",
#|          "The rate of convergence of the iterative Halley's method
#|           is cubic.",
#|          "There exist multidimensional versions of Halley's method.",
#|          wikipedia.org/wiki/Halley's_method`
#|
#{------------------------------------------------------------------------------
   from    enum      import Enum;
   from    enum      import IntEnum;
   import  math;
   import  os;
   import  time;
#-------------------------------------------------------------------------------
   from decimal                           import                               \
                                          Decimal;
   from generateTestProgramPurposeMessage import                               \
                                          generateTestProgramPurposeMessage;
   from generateTestProgramOutputHeader   import                               \
                                          generateTestProgramOutputHeader;
   from convertEcefToGeodetic             import                               \
                                          convertEcefToGeodetic;
   from convertGeodeticToEcef             import                               \
                                          convertGeodeticToEcef;
#-------------------------------------------------------------------------------
   executionTimeOfTrialFunctionCallsMicroSeconds = float( 'nan' );
#-------------------------------------------------------------------------------
   class EcefToGeodeticConversionStatusEnum( IntEnum ):
         #{---------------------------------------------------------------------
            SUCCESS_STATUS                 = +1;
            UNDETERMINED_STATUS            =  0;
            INVALID_ELLIPSOIDAL_FLATTENING = -1;
            INVALID_EQUATORIAL_RADIUS      = -2;
         #}---------------------------------------------------------------------
#-------------------------------------------------------------------------------
   radiansPerDegree               = math.pi    / 180.0;
   degreesPerRadian               = 180.0 / math.pi;
#-------------------------------------------------------------------------------
   arcSecondsPerArcMinute         =  60.0;
   arcMinutesPerDegree            =  60.0;
   microArcSecondsPerArcSecond    =   1.0E6;
   microArcSecondsPerDegree       = microArcSecondsPerArcSecond *              \
                                    arcSecondsPerArcMinute      *              \
                                    arcMinutesPerDegree;
   microArcSecondsPerRadian       = microArcSecondsPerDegree *                 \
                                    degreesPerRadian;
   nanoMetersPerMeter             = 1.0E9;
   microSecondsPerSecond          = 1.0E6;
#-------------------------------------------------------------------------------
#
#  The parameters:
#    [ 1 ]  Earth equatorial radius [meters]
#    [ 2 ]  Inverse ellipsoidal flattening factor
#  are set to the GRS1980 System values.
#
#-------------------------------------------------------------------------------
   earthEquatorialRadiusMeters             = 6378137.0E0;
   inverseEarthEllipsoidalFlatteningFactor =     298.257222101E0;
#-------------------------------------------------------------------------------
   earthEllipsoidalFlatteningFactor    =                                       \
                             1.0E0 /                                           \
                             inverseEarthEllipsoidalFlatteningFactor;
   earthEllipsoidalEccentricitySquared =                                       \
                             ( 2.0E0 - earthEllipsoidalFlatteningFactor ) *    \
                                       earthEllipsoidalFlatteningFactor;
#===============================================================================
#
#  STRATEGY:
#
#    [ 1 ]  Define true geodetic latitude and altitude
#           values along the 45-degree East geocentric
#           longitude meridian.
#
#    [ 2 ]  Generate true rectangular values based on the
#           true geodetic latitude, true geodetic altitude
#           and constant geocentric longitude' values.
#
#    [ 3 ]  Compute estimated geodetic values based on the
#           true rectangular values
#
#    [ 4 ]  Report the differences between the defined true
#           geodetic values and the estimated geodetic
#           values.
#
#===============================================================================
   specifiedFixedTrueGeocentricEastLongitudeRadians =                          \
                       radiansPerDegree *                                      \
                       specifiedFixedTrueGeocentricEastLongitudeDegrees;
#-------------------------------------------------------------------------------
#
#  Generate Purpose Message.
#
#-------------------------------------------------------------------------------
   generateTestProgramPurposeMessage(  );
#-------------------------------------------------------------------------------
#
#  Generate Header for Output
#
#-------------------------------------------------------------------------------
   generateTestProgramOutputHeader                                             \
           (                                                                   \
             specifiedFixedTrueGeocentricEastLongitudeDegrees                  \
           );
#-------------------------------------------------------------------------------
   trialTotalElapsedTimeMicroSeconds  =  0.0;
#-------------------------------------------------------------------------------
   deltaLatitudeDegrees               = 15.0;
#-------------------------------------------------------------------------------
   minimumAltitudeIndex               =  0;
   maximumAltitudeIndex               =  3;
   minimumLatitudeIndex               = -1;
   maximumLatitudeIndex               =  6;
#-------------------------------------------------------------------------------
   TEN_KILOMETER_IN_METERS            =  1.0E+4;
   ONE_THOUSAND_KILOMETERS_IN_METERS  =  1.0E+6;
#-------------------------------------------------------------------------------
   minimumTrueGeodeticLatitudeDegrees =  1.0E-9;
   maximumTrueGeodeticLatitudeDegrees = 89.999999999E0;
#-------------------------------------------------------------------------------
   maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs = 0.0;
   maximumGeodeticAltitudeAbsoluteErrorNanoMeters        = 0.0;
#-------------------------------------------------------------------------------
#
#  Loop over Geodetic Latitude values.
#
#-------------------------------------------------------------------------------
   for latitudeIndex in range(                                                 \
                                 minimumLatitudeIndex,                         \
                               ( maximumLatitudeIndex + 1 )                    \
                             ):
     #{-------------------------------------------------------------------------
        trueGeodeticNorthLatitudeDegrees = latitudeIndex *                     \
                                           deltaLatitudeDegrees;
     #--------------------------------------------------------------------------
        trueGeodeticNorthLatitudeDegrees =                                     \
                         min(                                                  \
                              maximumTrueGeodeticLatitudeDegrees,              \
                              max(                                             \
                                   trueGeodeticNorthLatitudeDegrees,           \
                                   minimumTrueGeodeticLatitudeDegrees          \
                                 )                                             \
                            );
     #--------------------------------------------------------------------------
        trueGeodeticNorthLatitudeRadians = radiansPerDegree *                  \
                                           trueGeodeticNorthLatitudeDegrees;
     #--------------------------------------------------------------------------
     #
     #  Loop over Geodetic Altitude values.
     #
     #--------------------------------------------------------------------------
        for altitudeIndex in range(                                            \
                                      minimumAltitudeIndex,                    \
                                    ( maximumAltitudeIndex + 1 )               \
                                  ):
          #{--------------------------------------------------------------------
             trueGeodeticAltitudeMeters = 0.0;
          #---------------------------------------------------------------------
             if( altitudeIndex == minimumAltitudeIndex ):
              #{----------------------------------------------------------------
                 trueGeodeticAltitudeMeters = -TEN_KILOMETER_IN_METERS;
              #}----------------------------------------------------------------
             else:
              #{----------------------------------------------------------------
                 trueGeodeticAltitudeMeters = altitudeIndex *                  \
                                              ONE_THOUSAND_KILOMETERS_IN_METERS;
              #}----------------------------------------------------------------
          #---------------------------------------------------------------------
          #  Convert the true geodetic coordinates into true rectangular
          #  coordinates.
          #---------------------------------------------------------------------
             ecefMetersReturnVector = [                                        \
                                        float( 'nan' ),                        \
                                        float( 'nan' ),                        \
                                        float( 'nan' )                         \
                                      ];
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             ecefMetersReturnVector =                                          \
             convertGeodeticToEcef                                             \
                    (                                                          \
                      earthEquatorialRadiusMeters,                             \
                      earthEllipsoidalEccentricitySquared,                     \
                      trueGeodeticNorthLatitudeRadians,                        \
                      specifiedFixedTrueGeocentricEastLongitudeRadians,        \
                      trueGeodeticAltitudeMeters                               \
                    );
          #---------------------------------------------------------------------
             xEcefMeters = ecefMetersReturnVector[ 0 ];
             yEcefMeters = ecefMetersReturnVector[ 1 ];
             zEcefMeters = ecefMetersReturnVector[ 2 ];
          #---------------------------------------------------------------------
          #  Use Halley's third order iterative method
          #  (applying only one iteration) to approximate the solution of
          #  the fourth order nonlinear algebraic geodetic equations.
          #---------------------------------------------------------------------
             startingElapsedTimeSeconds          = time.time(  );
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             NegativeInfinity                    = Decimal( '-infinity' );
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             estimatedGeodeticLatitudeRadians    = NegativeInfinity;
             estimatedGeocentricLongitudeRadians = NegativeInfinity;
             estimatedGeodeticAltitudeMeters     = NegativeInfinity;
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             convertEcefToGeodeticReturnedValue =                              \
             convertEcefToGeodetic                                             \
                    (                                                          \
                      earthEquatorialRadiusMeters,                             \
                      earthEllipsoidalFlatteningFactor,                        \
                      xEcefMeters,                                             \
                      yEcefMeters,                                             \
                      zEcefMeters                                              \
                    );
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             endingElapsedTimeSeconds           = time.time(  );
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             elapsedDurationTimeSeconds         =   endingElapsedTimeSeconds - \
                                                  startingElapsedTimeSeconds;
             elapsedDurationTimeMicroSeconds    = microSecondsPerSecond *      \
                                                  elapsedDurationTimeSeconds;
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             trialTotalElapsedTimeMicroSeconds =                               \
                                  trialTotalElapsedTimeMicroSeconds +          \
                                  elapsedDurationTimeMicroSeconds;
          #---------------------------------------------------------------------
             returnedFunctionStatus = convertEcefToGeodeticReturnedValue[ 0 ];
          #-------------------------------------;--------------------------------
             if(
                 returnedFunctionStatus
                 ==
                 EcefToGeodeticConversionStatusEnum.SUCCESS_STATUS
               ):
              #{----------------------------------------------------------------
              #  Geocentric to Geodetic conversion was successful.
              #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
              #
              #  Compute the residuals (errors):
              #
              #-----------------------------------------------------------------
                 estimatedGeodeticNorthLatitudeRadians   =                     \
                                  convertEcefToGeodeticReturnedValue[ 1 ];
                 estimatedGeocentricEastLongitudeRadians =                     \
                                  convertEcefToGeodeticReturnedValue[ 2 ];
                 estimatedGeodeticAltitudeMeters         =                     \
                                  convertEcefToGeodeticReturnedValue[ 3 ];
              #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 deltaGeodeticLatitudeRadians =                                \
                                      trueGeodeticNorthLatitudeRadians -       \
                                      estimatedGeodeticNorthLatitudeRadians;
                 deltaGeodeticLatitudeMicroArcSec =                            \
                                      microArcSecondsPerRadian  *              \
                                      deltaGeodeticLatitudeRadians;
              #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 deltaGeodeticAltitudeMeters =                                 \
                                      trueGeodeticAltitudeMeters -             \
                                      estimatedGeodeticAltitudeMeters;
                 deltaGeodeticAltitudeNanoMeters  =                            \
                                      nanoMetersPerMeter *                     \
                                      deltaGeodeticAltitudeMeters;
              #-----------------------------------------------------------------
                 maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs =       \
                   max                                                         \
                    (                                                          \
                      maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,   \
                      abs( deltaGeodeticLatitudeMicroArcSec )                  \
                    );
              #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 maximumGeodeticAltitudeAbsoluteErrorNanoMeters =              \
                   max                                                         \
                    (                                                          \
                      maximumGeodeticAltitudeAbsoluteErrorNanoMeters,          \
                      abs( deltaGeodeticAltitudeNanoMeters )                   \
                    );
              #-----------------------------------------------------------------
              #  Output results.
              #-----------------------------------------------------------------
                 print                                                         \
                  (           
                    "%+19.10f "  % ( trueGeodeticNorthLatitudeDegrees ),
                    "%+18.5f "   % ( trueGeodeticAltitudeMeters       ), 
                    "%+19.10e "  % ( deltaGeodeticLatitudeMicroArcSec ), 
                    "  %+18.10e" % ( deltaGeodeticAltitudeNanoMeters  ), 
                    sep=""
                  );
              #}----------------------------------------------------------------
             else:
              #{----------------------------------------------------------------
              #  Geocentric to Geodetic conversion has failed.
              #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
              #  Generate an error message.
              #-----------------------------------------------------------------
                 if(
                     returnedFunctionStatus
                     ==
                     EcefToGeodeticConversionStatusEnum.
                     INVALID_ELLIPSOIDAL_FLATTENING
                   ):
                  #{------------------------------------------------------------
                  #  Encountered invalid Earth ellipsoidal flattening value.
                  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  #  Generate an error message.
                  #-------------------------------------------------------------
                     print                                                     \
                      (
                         "\n\n\n",
                         "---------------------------------------------------",
                         "|",
                         "| ERROR:",
                         "|",
                         "|   Encountered invalid Earth ellipsoidal",
                         "|   flattening parameeter value.",
                         "|",
                         "|   The Earth ellipsoidal flattening parameter",
                         "|   values should be in the interval: [ 0.0, 1.0 ).",
                         "|",
                         "|   The Earth ellipsoidal flattening parameter value",
                         sep=os.linesep
                      );
                     print                                                     \
                      (
                         "|   was:-->",
                         end = ""
                      );
                     print                                                     \
                      (
                         "%+20.16e" % ( earthEllipsoidalFlatteningFactor )
                      );
                     print                                                     \
                      (
                         "|",
                         "---------------------------------------------------",
                         "\n\n\n",
                         sep=os.linesep
                      );
                  #}------------------------------------------------------------
                 elif(
                       returnedFunctionStatus
                       ==
                       EcefToGeodeticConversionStatusEnum.
                       INVALID_EQUATORIAL_RADIUS
                       ):
                  #{------------------------------------------------------------
                  #  Encountered invalid Earth equatorial radius.
                  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  #  Generate an error message.
                  #-------------------------------------------------------------
                     print                                                     \
                      (
                         "\n\n\n",
                         "---------------------------------------------------",
                         "|",
                         "| ERROR:",
                         "|",
                         "|   Encountered invalid Earth equatorial",
                         "|   radius value.",
                         "|",
                         "|   The Earth equatorial radius value must",
                         "|   be strictly positive.",
                         "|",
                         "|   The Earth equatorial radius value was:",
                         sep=os.linesep
                      );
                     print                                                     \
                      (
                         "|     ",
                         end = ""
                      );
                     print                                                     \
                      (
                         "%+20.16e" % ( earthEquatorialRadiusMeters )
                      );
                     print                                                     \
                      (
                         "|",
                         "---------------------------------------------------",
                         "\n\n\n",
                         sep=os.linesep
                      );
                  #}------------------------------------------------------------
                 else:
                  #{------------------------------------------------------------
                  #  Geodetic conversion status is undetermined.
                  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  #  Generate an error message.
                  #-------------------------------------------------------------
                     print                                                     \
                      (
                         "\n\n\n",
                         "---------------------------------------------------",
                         "|",
                         "| ERROR:",
                         "|",
                         "|   Encountered undetermined Geodetic",
                         "|   conversion status.",
                         "|",
                         "---------------------------------------------------",
                         "\n\n\n",
                         sep=os.linesep
                          );
                  #}------------------------------------------------------------
              #}----------------------------------------------------------------
          #---------------------------------------------------------------------
          #  End of altitude loop.
          #}--------------------------------------------------------------------
     #--------------------------------------------------------------------------
     #  End of latitude loop.
     #}-------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#  Finish the output report.
#
#-------------------------------------------------------------------------------
   print                                                                       \
    (
      "============================================" +
      "============================================" 
    );
   print( "\n\n\n" );
#-------------------------------------------------------------------------------
   executionTimeOfTrialFunctionCallsMicroSeconds =                             \
                                  trialTotalElapsedTimeMicroSeconds;
#-------------------------------------------------------------------------------
#
#  Generate report on timing of the current trial.
#
#-------------------------------------------------------------------------------
   print                                                                       \
    (
      "============================================" +
      "============================================" 
    );
   print                                                                       \
    (
      "|",
      "| TIMING RESULTS FOR CURRENT TRIAL:",
      "|",
      "|   Cumulative execution time over all",
      sep=os.linesep
    );
   print                                                                       \
    (
      "|      'convertEcefToGeodetic' function calls:-->",
      end = ""
    );
   print                                                                       \
    (
      "%+14.6f" % ( executionTimeOfTrialFunctionCallsMicroSeconds ),
      end = ""
    );
   print                                                                       \
    (
      " [microseconds]"
    );
   print                                                                       \
    (
      "|"
    );
   print                                                                       \
    (
      "|---------------------------------------------------------------------" +
      "------------------"
    );
   print                                                                       \
    (
      "|",
      "| COORDINATE CONVERSION TIMING:",
      "|",
      "| COORDINATE CONVERSION TIMING MEASUREMENTS OCCUR OVER A TRIAL",
      "|",
      "| A TRIAL OCCURS OVER A SPECIFIED TRUE GEOCENTRIC",
      "| LONGITUDE (ie. ON A SPECIFIED GEOCENTRIC MEDIDIAN)",
      "|",
      "| A TRIAL CONSISTS OF:",
      "|",
      "|   Performing the following 32 ECEF rectangular",
      "|   X, Y, Z coordinates to geodetic latitude and",
      "|   altitude conversions.",
      "|",
      "|     [ 1 ]  Converting ECEF rectangular X, Y, Z coordinates",
      "|            at each 15 degrees of true geodetic latitude",
      "|            along the specified true East longitude meridian",
      "|            from the equator to the north pole.",
      "|",
      "|     [ 2 ]  At each true geodetic latitude,",
      "|            perform seperate geodetic coordinate conversions",
      "|            at each of four specified true geodetic altitudes.",
      "|",
      "|   Report the sum of the execution times over each of",
      "|   the coordinate conversion function calls involved in",
      "|   the 32 ECEF rectangular coorindates conversions to",
      "|   geodetic coordinates.",
      "|",
      sep=os.linesep
    );
   print                                                                       \
    (
      "============================================" +
      "============================================" 
    );
   print( "\n\n\n" );
#-------------------------------------------------------------------------------
   print                                                                       \
    (
      "============================================" +
      "============================================" 
    );
   print                                                                       \
    (
      "|",
      "|  MAXIMUM ABSOLUTE ERRORS OVER ONE TRIAL:",
      "|",
      "|    Maximum geodetic north latitude absolute error",
      sep=os.linesep
    );
   print                                                                       \
    (
      "|      is:-->",
      "%+14.6f" % ( maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs ),
      end = ""
    );
   print                                                                       \
    (
      " [microarcseconds]"
    );
   print                                                                       \
    (
      "|",
      "|    Maximum geodetic altitude absolute error",
      sep=os.linesep
    );
   print                                                                       \
    (
      "|      is:-->",
      "%+14.6f"  %( maximumGeodeticAltitudeAbsoluteErrorNanoMeters ),
      end = ""
    );
   print                                                                       \
    (
      " [nanometers]"
    );
   print                                                                       \
    (
      "|"
    );
   print                                                                       \
    (
      "============================================" +
      "============================================"
    );
   print( "\n\n\n" );
#-------------------------------------------------------------------------------
   returnValue = [
                   executionTimeOfTrialFunctionCallsMicroSeconds,
                   maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
                   maximumGeodeticAltitudeAbsoluteErrorNanoMeters
                 ];
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   return( returnValue );
#}------------------------------------------------------------------------------

