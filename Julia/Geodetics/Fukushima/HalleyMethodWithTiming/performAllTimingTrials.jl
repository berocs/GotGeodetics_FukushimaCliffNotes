function
performAllTimingTrials(
                        numberTrials,
                        startingGeocentricEastLongitudeDegrees,
                        deltaGeocentricEastLongitudeDegrees
                      )
#-------------------------------------------------------------------------------
#|
#| FUNCTION:
#|
#|   performAllTimingTrials
#|
#|-----------------------------------------------------------------------------
#|
#| PURPOSE:
#|
#|   To perform all timing trials of converting Earth-Center Earth-Fixed (ECEF)
#|   retangular coordinates to geodetic coordinates for a specified
#|   reference ellipsoid.
#|
#|-----------------------------------------------------------------------------
#|
#| INPUT(s):
#|
#|   numberTrials
#|     The number of trials.
#|     UNIT(s):  [nondimensional]
#|
#|   startingGeocentricEastLongitudeDegrees
#|     The starting geocentric East longitude.
#|     UNIT(s):  [degrees]
#|
#|   deltaGeocentricEastLongitudeDegrees
#|     The delta geocentric East longitude.
#|     UNIT(s):  [degrees]
#|
#|-----------------------------------------------------------------------------
#|
#| OUTPUT(s):
#|
#|   None
#|
#|-----------------------------------------------------------------------------
#|
#| RETURN VALUE(s):
#|
#|   totalTrialsExecutionTimeMicroSeconds
#|
#|     This function will return sum of the execution times for each of the
#|     'convertEcefToGeodetic' function calls involved in all the specified
#|     number of trials.
#|     UNIT(s):  [microseconds]
#|
#|-----------------------------------------------------------------------------
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
#|-----------------------------------------------------------------------------
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
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#{------------------------------------------------------------------------------
#
#  Loop over all timing trials.
#
#-------------------------------------------------------------------------------
   totalTrialsExecutionTimeMicroSeconds        = 0.0;
   totalTrialsMaxGeodeticNorthLatitudeAbsError = 0.0;
   totalTrialsMaxGeodeticAltitudeAbsError      = 0.0;
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   for trialIndex in 1 : numberTrials
     #{-------------------------------------------------------------------------
        specifiedFixedTrueGeocentricEastLongitudeDegrees =
                 (
                   startingGeocentricEastLongitudeDegrees
                   +
                   (
                     ( trialIndex - 1 )
                     *
                     deltaGeocentricEastLongitudeDegrees
                   )
                 );
     #-------------------------------------------------------------------------
     #  Compute coordinate conversions over the specified geocentric meridian.
     #--------------------------------------------------------------------------
        executeOneTrialConvertEcefToGeodeticReturnValue =
        executeOneTrialConvertEcefToGeodetic(
                 specifiedFixedTrueGeocentricEastLongitudeDegrees
                                            );
     #--------------------------------------------------------------------------
        executionTimeOfTrialFunctionCallsMicroSeconds         =
                      executeOneTrialConvertEcefToGeodeticReturnValue[ 1 ]; 
        maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs =
                      executeOneTrialConvertEcefToGeodeticReturnValue[ 2 ]; 
        maximumGeodeticAltitudeAbsoluteErrorNanoMeters        =
                      executeOneTrialConvertEcefToGeodeticReturnValue[ 3 ]; 
     #--------------------------------------------------------------------------
        totalTrialsExecutionTimeMicroSeconds =
                            totalTrialsExecutionTimeMicroSeconds +
                            executionTimeOfTrialFunctionCallsMicroSeconds;
     #--------------------------------------------------------------------------
         totalTrialsMaxGeodeticNorthLatitudeAbsError =
           max(
                 totalTrialsMaxGeodeticNorthLatitudeAbsError,
                 maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs
              );
     #--------------------------------------------------------------------------
         totalTrialsMaxGeodeticAltitudeAbsError =
           max(
                 totalTrialsMaxGeodeticAltitudeAbsError,
                 maximumGeodeticAltitudeAbsoluteErrorNanoMeters
              );
     #}-------------------------------------------------------------------------
   end;
#-------------------------------------------------------------------------------
   returnValue = [
                   totalTrialsExecutionTimeMicroSeconds,
                   totalTrialsMaxGeodeticNorthLatitudeAbsError,
                   totalTrialsMaxGeodeticAltitudeAbsError
                 ];
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   return( returnValue );
#-------------------------------------------------------------------------------
   end;
#}------------------------------------------------------------------------------



