#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#
#  MAIN PROGRAM:
#
#    testConvertEcefToGeodetic 
#
#-------------------------------------------------------------------------------
#
#  PURPOSE:
#    To test the conversion of specified geocentric retangular coordinates
#    to geodetic coordinates for a specified reference ellipsoid.
#
#-------------------------------------------------------------------------------
#
#  METHOD:
#
#    [ 1 ] Uses the economic third-order Halley's method to
#          approximate a solution for the general non-linear
#          geodetic equation numerically.
#
#    [ 2 ] Uses only one iteration of the iterative Halley's
#          method to achieve near double precision accuracy.
#
#    [ 3 ] Uses a technique to avoid division operations which
#          significantly accelerates the backward transformation
#          without degrading the precision.
#
#-------------------------------------------------------------------------------
#
#  AUTHOR(s):
#
#    [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
#           National Astronomical Observatory of Japan (NAOJ)
#           Address:  2-21-1, Ohsawa, Mitaka, Tokyo 181-8588, Japan
#           Phone:    +81-422-34-3613
#
#-------------------------------------------------------------------------------
#
#  REFERENCE(s):
#
#    [ 1 ]  "Transformation from Cartesian to geodetic
#            coordinates accelerated by Halley's method",
#           Toshio Fukushima,
#           Journal Of Geodesy (2006),
#           Volume 79,
#           Pages 689-693
#
#    [ 2 ]  "Fast transform from geocentric to geodetic coordinates",
#           Toshio Fukushima,
#           Journal Of Geodesy (1999),
#           Volume 73,
#           Pages 603–610
#
#    [ 3 ]  "Geometric Geodesy, Part A",
#           "A set of lecture notes which are an introduction to
#            ellipsoidal geometry related to geodesy.",
#            R. E. Deakin and M. N. Hunter,
#            School of Mathematical and Geospatial Sciences,
#            RMIT University,
#            Melbourne, Australia,
#            January 2013
#            www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
#
#    [ 4 ]  'Various parameterizations of "latitude" equation -
#            Cartesian to geodetic coordinates transformation',
#            Marcin Ligas,
#            Journal of Geodetic Science,
#            Pages 87 - 94,
#            2013
#
#    [ 5 ]  "In numerical analysis, Halley's method is a root-finding
#            algorithm used for functions of one real variable with a
#            continuous second derivative.",
#           "The rate of convergence of the iterative Halley's method
#            is cubic.",
#           "There exist multidimensional versions of Halley's method.",
#           wikipedia.org/wiki/Halley's_method`
#
#------------------ ------------------------------------------------------------

#{----------------- ------------------------------------------------------------
   include( "./convertEcefToGeodetic.jl"                       );
   include( "./convertGeodeticToEcef.jl"                       );
   include( "./generateTestProgramPurposeMessage.jl"           );
   include( "./generateTestProgramOutputHeader.jl"             );
   include( "./generateConvertGeodeticToEcefUsageMessage.jl"   );
   include( "./generateConvertGeodeticToEcefPurposeMessage.jl" );
   include( "./generateConvertEcefToGeodeticUsageMessage.jl"   );
   include( "./generateConvertEcefToGeodeticPurposeMessage.jl" );
#-------------------------------------------------------------------------------
   using Printf;
#-------------------------------------------------------------------------------
   @enum(
          ECEF_TO_GEODETIC_CONVERSION_STATUS_ENUM,
          SUCCESS_STATUS                               = +1,
          UNDETERMINED_STATUS                          =  0,
          INVALID_ELLIPSOIDAL_FLATTENING               = -1,
          INVALID_EQUATORIAL_RADIUS                    = -2,
          INVALID_COMPLIMENTARY_ELLIPSOIDAL_FLATTENING = -3
        );
#-------------------------------------------------------------------------------
#  Define printFormatted macro.
#-------------------------------------------------------------------------------
   printFormatted( formatString, args... ) =
        @eval( @printf( $( formatString ), $( args... ) ) );
#-------------------------------------------------------------------------------
   microSecondsPerNanoSecond    = 0.001;
#-------------------------------------------------------------------------------
   radiansPerDegree             = pi    / 180.0;
   degreesPerRadian             = 180.0 / pi;
   arcSecondsPerArcMinute       =  60.0;
   arcMinutesPerDegree          =  60.0;
   microArcSecondsPerArcSecond  =   1.0E6;
   microArcSecondsPerDegree     = microArcSecondsPerArcSecond *
                                  arcSecondsPerArcMinute      *
                                  arcMinutesPerDegree;
   microArcSecondsPerRadian     = microArcSecondsPerDegree    *
                                  degreesPerRadian;
   nanoMetersPerMeter           = 1.0E9;
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
   earthEllipsoidalFlatteningFactor    =
                             1.0E0 /
                             inverseEarthEllipsoidalFlatteningFactor;
   earthEllipsoidalEccentricitySquared =
                             ( 2.0E0 - 
                               earthEllipsoidalFlatteningFactor ) *
                               earthEllipsoidalFlatteningFactor;
#-------------------------------------------------------------------------------
#
#  Fixed the longitude at 45 degrees for test purposes.
#
#-------------------------------------------------------------------------------
   specifiedFixedGeocentricEastLongitudeDegrees = 45.0;
#-------------------------------------------------------------------------------
   specifiedFixedGeocentricEastLongitudeRadians =
                          radiansPerDegree *
                          specifiedFixedGeocentricEastLongitudeDegrees;
#-------------------------------------------------------------------------------
#
#  Generate Purpose Message.
#
#-------------------------------------------------------------------------------
   generateTestProgramPurposeMessage(  );
#-------------------------------------------------------------------------------
let
#{------------------------------------------------------------------------------
   totalElapsedTimeMicroSeconds                          = 0.0;
   maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs = 0.0;
   maximumGeodeticAltitudeAbsoluteErrorNanoMeters        = 0.0;
#-------------------------------------------------------------------------------
#
#  Invoke the timed function 'convertEcefToGeodetic' initially once to
#  get it 'just-in-time' compiled.
#
#-------------------------------------------------------------------------------
   xEcefMeters = earthEquatorialRadiusMeters;
   yEcefMeters = 0.0;
   zEcefMeters = 0.0;
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   geodeticReturnedDataVector =
           convertEcefToGeodetic(
                                  earthEquatorialRadiusMeters,
                                  earthEllipsoidalFlatteningFactor,
                                  xEcefMeters,
                                  yEcefMeters,
                                  zEcefMeters
                                );
#-------------------------------------------------------------------------------
#
#  Generate Header for Output
#
#-------------------------------------------------------------------------------
   generateTestProgramOutputHeader(
             specifiedFixedGeocentricEastLongitudeDegrees
                                  );
#-------------------------------------------------------------------------------
   deltaLatitudeDegrees                    =  15.0;
#-------------------------------------------------------------------------------
   minimumAltitudeIndex                    =   0;
   maximumAltitudeIndex                    =   3;
   minimumLatitudeIndex                    =  -1;
   maximumLatitudeIndex                    =   6;
#-------------------------------------------------------------------------------
   MINIMUM_GEODETIC_NORTH_LATITUDE_DEGREES =   0.000000001E0;
   MAXIMUM_GEODETIC_NORTH_LATITUDE_DEGREES =  89.999999999E0;
#-------------------------------------------------------------------------------
#
#  Loop over Geodetic Latitude values.
#
#-------------------------------------------------------------------------------
   for latitudeIndex in minimumLatitudeIndex : maximumLatitudeIndex
     #{-------------------------------------------------------------------------
        trueGeodeticNorthLatitudeDegrees = latitudeIndex *
                                           deltaLatitudeDegrees;
     #--------------------------------------------------------------------------
     #  Set the geodetic latitude to be between 0 and 90 degrees
     #  (exclusive).
     #  Set the geodetic latitude to be between:
     #  0.000000001E0 and 89.999999999E0 (inclusive).
     #--------------------------------------------------------------------------
        trueGeodeticNorthLatitudeDegrees =
                            min(
                                 MAXIMUM_GEODETIC_NORTH_LATITUDE_DEGREES,
                                 max(
                                      trueGeodeticNorthLatitudeDegrees,
                                      MINIMUM_GEODETIC_NORTH_LATITUDE_DEGREES
                                    )
                               );
     #--------------------------------------------------------------------------
        trueGeodeticNorthLatitudeRadians = radiansPerDegree *
                                           trueGeodeticNorthLatitudeDegrees;
     #--------------------------------------------------------------------------
     #  Loop over Geodetic Altitude values.
     #--------------------------------------------------------------------------
        for altitudeIndex in minimumAltitudeIndex : maximumAltitudeIndex
          #{--------------------------------------------------------------------
             trueGeodeticAltitudeMeters = 0.0;
          #---------------------------------------------------------------------
             if( altitudeIndex == 0 )
              #{----------------------------------------------------------------
                 trueGeodeticAltitudeMeters = -10000.0E0;
              #}----------------------------------------------------------------
             else
              #{----------------------------------------------------------------
                 trueGeodeticAltitudeMeters = altitudeIndex * 1000000.0E0;
              #}----------------------------------------------------------------
             end;
          #---------------------------------------------------------------------
             ecefVectorReturnValue =
             convertGeodeticToEcef(
                                    earthEquatorialRadiusMeters,
                                    earthEllipsoidalEccentricitySquared,
                                    trueGeodeticNorthLatitudeRadians,
                                    specifiedFixedGeocentricEastLongitudeRadians,
                                    trueGeodeticAltitudeMeters
                                  );
          #---------------------------------------------------------------------
             xEcefMeters = ecefVectorReturnValue[ 1 ];
             yEcefMeters = ecefVectorReturnValue[ 2 ];
             zEcefMeters = ecefVectorReturnValue[ 3 ];
          #---------------------------------------------------------------------
          #
          #  Halley's method (applying only one iteration)
          #
          #---------------------------------------------------------------------
             NegativeInfinity                        = -1.0 / 0.0;
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             estimatedGeodeticNorthLatitudeRadians   = NegativeInfinity;
             estimatedGeocentricEastLongitudeRadians = NegativeInfinity;
             estimatedGeodeticAltitudeMeters         = NegativeInfinity;
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             startingElapsedTimeNanoSeconds          = time_ns(  );
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             geodeticReturnedDataVector =
              convertEcefToGeodetic(
                                     earthEquatorialRadiusMeters,
                                     earthEllipsoidalFlatteningFactor,
                                     xEcefMeters,
                                     yEcefMeters,
                                     zEcefMeters
                                   );
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             endingElapsedTimeNanoSeconds  = time_ns(  );
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             currentElapsedTimeNanoSeconds =
                                   endingElapsedTimeNanoSeconds -
                                   startingElapsedTimeNanoSeconds; 
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             currentElapsedTimeMicroSeconds =
                                  microSecondsPerNanoSecond *
                                  currentElapsedTimeNanoSeconds;
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             totalElapsedTimeMicroSeconds   =
                                  totalElapsedTimeMicroSeconds +
                                  currentElapsedTimeMicroSeconds;
          #---------------------------------------------------------------------
             returnedFunctionStatus = geodeticReturnedDataVector[ 1 ];
          #---------------------------------------------------------------------
             if( returnedFunctionStatus == Int( SUCCESS_STATUS ) )
              #{----------------------------------------------------------------
              #  Geocentric to Geodetic conversion was successful.
              #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
              #
              #  Obtain the geodetic results.
              #
              #-----------------------------------------------------------------
                 estimatedGeodeticNorthLatitudeRadians   =
                                              geodeticReturnedDataVector[ 2 ];
                 estimatedGeocentricEastLongitudeRadians =
                                              geodeticReturnedDataVector[ 3 ];
                 estimatedGeodeticAltitudeMeters         =
                                              geodeticReturnedDataVector[ 4 ];
              #-----------------------------------------------------------------
              #
              #  Determine the geodetic residuals.
              #
              #-----------------------------------------------------------------
                 deltaGeodeticLatitudeRadians =
                                      trueGeodeticNorthLatitudeRadians -
                                      estimatedGeodeticNorthLatitudeRadians;
                 deltaGeodeticLatitudeMicroArcSec = 
                                      microArcSecondsPerRadian  *
                                      deltaGeodeticLatitudeRadians;
              #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 deltaGeodeticAltitudeMeters =
                                      trueGeodeticAltitudeMeters -
                                      estimatedGeodeticAltitudeMeters;
                 deltaGeodeticAltitudeNanoMeters  =
                                      nanoMetersPerMeter *
                                      deltaGeodeticAltitudeMeters;
              #-----------------------------------------------------------------
                 maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs =
                   max(
                      maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
                      abs( deltaGeodeticLatitudeMicroArcSec )
                    );
              #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 maximumGeodeticAltitudeAbsoluteErrorNanoMeters =
                   max(
                      maximumGeodeticAltitudeAbsoluteErrorNanoMeters,
                      abs( deltaGeodeticAltitudeNanoMeters )
                    );
              #-----------------------------------------------------------------
              #  Output residual results.
              #-----------------------------------------------------------------
                 printFormatted(
                          stdout,
                          "%+19.10f %+18.5f  %+19.10e  %+18.10e\n",
                          trueGeodeticNorthLatitudeDegrees,
                          trueGeodeticAltitudeMeters,
                          deltaGeodeticLatitudeMicroArcSec,
                          deltaGeodeticAltitudeNanoMeters
                        );
              #}----------------------------------------------------------------
             else
              #{----------------------------------------------------------------
              #  Geocentric to Geodetic conversion has failed.
              #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
              #  Generate an error message.
              #-----------------------------------------------------------------
                 if(
                     returnedFunctionStatus
                     ==
                     Int( INVALID_ELLIPSOIDAL_FLATTENING )
                   )
                  #{------------------------------------------------------------
                  #  Encountered invalid Earth ellipsoidal flattening value.
                  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  #  Generate an error message.
                  #-------------------------------------------------------------
                     @printf( "\n\n\n" );
                     @printf(       
                          "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
                          "-----------------------------------------------",
                          "|",
                          "| ERROR:",
                          "|",
                          "|   Encountered invalid Earth ellipsoidal",
                          "|   flattening value.",       
                          "|",
                          "|   The Earth ellipsoidal flattening values",
                          "|   should be in the interval:  [ 0.0, 1.0 ).",
                          "|"
                            );
                     @printf(       
                          "%s\n%s\n",
                          "|   The Earth ellipsoidal flattening value",
                          "|   was:"
                            );
                     @printf(       
                          "%s%+20.16e\n",
                          "|     ",
                          earthEllipsoidalFlatteningFactor
                            );
                     @printf(       
                          "%s\n%s\n",       
                          "|",
                          "-----------------------------------------------"
                            );
                     @printf( "\n\n\n" );
                  #}------------------------------------------------------------
                 elseif(
                         returnedFunctionStatus
                         ==
                         Int( INVALID_EQUATORIAL_RADIUS )
                       )
                  #{------------------------------------------------------------
                  #  Encountered invalid Earth equatorial radius.
                  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  #  Generate an error message.
                  #-------------------------------------------------------------
                     @printf( "\n\n\n" );
                     @printf(       
                          "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
                          "-----------------------------------------------",
                          "|",
                          "| ERROR:",
                          "|",
                          "|   Encountered invalid Earth equatorial",
                          "|   radius value.",
                          "|",
                          "|   The Earth equatorial radius value must",
                          "|   be strictly positive.",
                          "|"
                            );
                     @printf(       
                          "%s\n",
                          "|   The Earth equatorial radius value was:"
                            );
                     @printf(       
                          "%s%+20.16e\n",
                          "|     ",
                          earthEquatorialRadiusMeters,
                            );
                     @printf(       
                          "%s\n%s\n",       
                          "|",
                          "-----------------------------------------------"
                            );
                     @printf( "\n\n\n" );
                  #}------------------------------------------------------------
                 elseif(
                         returnedFunctionStatus
                         ==
                         Int( INVALID_COMPLIMENTARY_ELLIPSOIDAL_FLATTENING )
                       )
                  #{------------------------------------------------------------
                  #  Encountered invalid squared complimentary Earth ellipsoid
                  #  parameter value.
                  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  #  Generate an error message.
                  #-------------------------------------------------------------
                     @printf( "\n\n\n" );
                     @printf(       
                          "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
                          "-----------------------------------------------",
                          "|",
                          "| ERROR:",
                          "|",
                          "|    The squared complimentary Earth ellipsoid",
                          "|    parameter value is invalid.",
                          "|",
                          "|    Squared complementary Earth ellipsoid",
                          "|    parameter value is expected to be positive.",
                          "|"
                            );
                     @printf(       
                          "%s\n%s\n",       
                          "|",
                          "-----------------------------------------------"
                            );
                     @printf( "\n\n\n" );
                  #}------------------------------------------------------------
                 else
                  #{------------------------------------------------------------
                  #  Geodetic conversion status is undetermined.
                  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  #  Generate an error message.
                  #-------------------------------------------------------------
                     @printf( "\n\n\n" );
                     @printf(       
                          "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
                          "-----------------------------------------------",
                          "|",
                          "| ERROR:",
                          "|",
                          "|   Encountered undetermined Geodetic",
                          "|   conversion status.",
                          "|",
                          "-----------------------------------------------"
                            );
                     @printf( "\n\n\n" );
                  #}------------------------------------------------------------
                 end;
              #}----------------------------------------------------------------
             end;
          #}--------------------------------------------------------------------
        end;
     #}-------------------------------------------------------------------------
   end;
#-------------------------------------------------------------------------------
#  Finish the output report.
#-------------------------------------------------------------------------------
   @printf(
            "%s%s\n",
            "============================================",
            "============================================"
          );
#-------------------------------------------------------------------------------
   @printf( "\n\n\n" );
   @printf(
            "%s%s\n%s\n%s\n%s\n%s\n",
            "============================================",
            "============================================",
            "|",
            "| TIMING RESULTS FOR ONE TRIAL:",
            "|",
            "|   Cumulative execution time over all",
          );
   @printf(
            "%s%+10.2f%s\n",
            "|     'convertEcefToGeodetic' function calls:-->",
            totalElapsedTimeMicroSeconds,
            " [microseconds]"
          );
   @printf(
            "%s\n%s%s\n",
            "|",
            "============================================",
            "============================================"
          );
   @printf( "\n\n\n" );
#-------------------------------------------------------------------------------
   @printf(
            "%s%s\n%s\n%s\n%s\n%s\n",
            "============================================",
            "============================================",
            "|",
            "|  MAXIMUM ABSOLUTE ERRORS OVER ONE TRIAL:",
            "|",
            "|    Maximum geodetic north latitude absolute error"
          );
   @printf(
            "%s%+14.6f%s\n",
            "|      is:-->",
             maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
            " [microarcseconds]"
          );
   @printf(
            "%s\n%s\n%s%+14.6f%s\n",
            "|",
            "|    Maximum geodetic altitude absolute error",
            "|      is:-->",
            maximumGeodeticAltitudeAbsoluteErrorNanoMeters,
            " [nanometers]"
          );
   @printf(
            "%s\n%s%s\n",
            "|",
            "============================================",
            "============================================"
          );
   @printf( "\n\n\n" );
#}------------------------------------------------------------------------------
   end;
#}------------------------------------------------------------------------------



