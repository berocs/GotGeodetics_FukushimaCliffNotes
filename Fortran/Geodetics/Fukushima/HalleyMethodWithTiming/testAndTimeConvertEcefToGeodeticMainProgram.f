C===============================================================================
C        1         2         3         4         5         6         7         8
C2345678901234567890123456789012345678901234567890123456789012345678901234567890
C===============================================================================
       PROGRAM
     2 testAndTimeConvertEcefToGeodeticMainProgram
C-------------------------------------------------------------------------------
C|
C|  MAIN PROGRAM:
C|
C|    testAndTimeConvertEcefToGeodeticMainProgram
C|
C|------------------------------------------------------------------------------
C|
C|  PURPOSE:
C|
C|    Test accuracy and timing of conversion of Earth-Centered
C|    Earth-Fixed (ECEF) retangular coordinates to geodetic
C|    coordinates for a specified reference ellipsoid.
C|
C|------------------------------------------------------------------------------
C|
C|  METHOD OF CONVERSION FOR EACH ECEF X, Y, Z RECTANGULAR
C|  COORDINATES TO GEODETIC COORDINATES:
C|
C|    [ 1 ] Uses the economic third-order Halley's method to
C|          approximate a solution for the general non-linear
C|          geodetic equation numerically.
C|
C|    [ 2 ] Uses only one iteration of the iterative Halley's
C|          method.
C|
C|    [ 3 ] Uses a technique to avoid division operations which
C|          significantly accelerates the geodetic transformation
C|          without degrading the precision.
C|
C|------------------------------------------------------------------------------
C|
C|  STRATEGY FOR MEASURING CONVERION ACCURACY OF ONE SET OF
C|  ECEF COORDINATES CONVERTED TO GEODETIC COORDINATES:
C|
C|    [ 1 ]  Define true geodetic latitude and altitude
C|`          values along the East geocentric longitude
C|   `       meridian at specified longitude [degrees].
C|
C|    [ 2 ]  Using the exact geodetic to ECEF rectangular
C|           conversion function, generate true rectangular
C|           ECEF X, Y and Z coordinate values based on the
C|           specified true geodetic latitude, true geodeti
C|           altitude and the specifed constant true geocentric
C|           longitude value.
C|
C|    [ 3 ]  Compute estimated geodetic latitude and altitude
C|           values based on the true rectangular ECEF X, Y
C|           and Z values.
C|
C|    [ 4 ]  Report the differences between the defined true
C|           geodetic latitude and altitude values and the
C|           estimated geodetic latitude and altitude values.
C|
C|------------------------------------------------------------------------------
C|
C|  COORDINATE CONVERSION TIMING:
C|
C|  COORDINATE CONVERSION TIMING MEASUREMENTS OCCUR OVER A TRIAL
C|
C|  A TRIAL OCCURS OVER A SPECIFIED TRUE GEOCENTRIC
C|  LONGITUDE (ie. ON A SPECIFIED GEOCENTRIC MEDIDIAN)
C|
C|  A TRIAL CONSISTS OF:
C|
C|    Performing the following 32 ECEF rectangular
C|    X, Y, Z coordinates to geodetic latitude and
C|    altitude conversions.
C|
C|      [ 1 ]  Converting ECEF rectangular X, Y, Z coordinates
C|             at each 15 degrees of true geodetic latitude
C|             along the specified true East longitude meridian
C|             from the equator to the north pole.
C|
C|      [ 2 ]  At each true geodetic latitude,
C|             perform seperate geodetic coordinate conversions
C|             at each of four specified true geodetic altitudes.
C|
C|    Report the sum of the execution times over each of
C|    the coordinate conversion function calls involved in
C|    the 32 ECEF rectangular coorindates conversions to
C|    geodetic coordinates.
C|
C|------------------------------------------------------------------------------
C|
C|  AUTHOR(s):
C|
C|    [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
C|           National Astronomical Observatory of Japan (NAOJ)
C|           Address:  2-21-1, Ohsawa, Mitaka, Tokyo 181-8588, Japan
C|           Phone:    +81-422-34-3613
C|
C|------------------------------------------------------------------------------
C|
C|  REFERENCE(s):
C|
C|    [ 1 ] "Transformation from Cartesian to geodetic
C|           coordinates accelerated by Halley''s method",
C|          Toshio Fukushima,
C|          Journal Of Geodesy (2006),
C|          Volume 79,
C|          Pages 689-693
C|
C|    [ 2 ] "Fast transform from geocentric to geodetic coordinates"
C|          Toshio Fukushima,
C|          Journal Of Geodesy (1999),
C|          Volume 73,
C|          Pages 603–610
C|
C|    [ 3 ] "Geometric Geodesy, Part A",
C|          "A set of lecture notes which are an introduction to
C|           ellipsoidal geometry related to geodesy.",
C|           R. E. Deakin and M. N. Hunter,
C|           School of Mathematical and Geospatial Sciences,
C|           RMIT University,
C|           Melbourne, Australia,
C|           January 2013
C|           www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
C|
C|    [ 4 ] 'Various parameterizations of "latitude" equation -
C|           Cartesian to geodetic coordinates transformation',
C|           Marcin Ligas,
C|           Journal of Geodetic Science,
C|           Pages 87 - 94,
C|           2013
C|
C|    [ 5 ] "In numerical analysis, Halley's method is a root-finding
C|           algorithm used for functions of one real variable with a
C|           continuous second derivative.",
C|          "The rate of convergence of the iterative Halley's method
C|           is cubic.",
C|          "There exist multidimensional versions of Halley's method.",
C|          wikipedia.org/wiki/Halley's_method`
C|
C-------------------------------------------------------------------------------
       IMPLICIT   NONE
C-------------------------------------------------------------------------------
       INTEGER*4  STANDARD_OUTPUT
C     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       INTEGER*4  numberTrials
       INTEGER*4  trialIndex
       REAL*8     specifiedFixedTrueGeocentricEastLongitudeDegrees
       REAL*8     startingTrueGeocentricEastLongitudeDegrees
       REAL*8     deltaTrueGeocentricEastLongitudeDegrees
       REAL*8     totalTrialsExecutionTimeMicroSeconds
       REAL*8     executionTimeOfTrialFunctionCallsMicroSeconds
       REAL*8     averageTrialExecutionTimeMicroSeconds
       REAL*8     maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs
       REAL*8     maximumGeodeticAltitudeAbsoluteErrorNanoMeters
       REAL*8     maxTotalGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs
       REAL*8     maxTotalGeodeticAltitudeAbsoluteErrorNanoMeters
C-------------------------------------------------------------------------------
       STANDARD_OUTPUT   = 6
C     --------------------------------------------------------------------------
       CALL
     2 generateTestProgramPurposeMessage(  )
C     --------------------------------------------------------------------------
C
C      Loop over all timing trials.
C
C     --------------------------------------------------------------------------
       numberTrials                               = 4 * 360;
       startingTrueGeocentricEastLongitudeDegrees = 0.0
       deltaTrueGeocentricEastLongitudeDegrees    = 360.0 / numberTrials
       totalTrialsExecutionTimeMicroSeconds       = 0.0
C     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
       maxTotalGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs = 0.0
       maxTotalGeodeticAltitudeAbsoluteErrorNanoMeters        = 0.0
C     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
       DO  trialIndex = 1,                          
     2                  numberTrials
C        {----------------------------------------------------------------------
           specifiedFixedTrueGeocentricEastLongitudeDegrees =  
     2              startingTrueGeocentricEastLongitudeDegrees
     3              +
     4              (
     5                ( trialIndex - 1 )
     6                *
     7                deltaTrueGeocentricEastLongitudeDegrees
     8              )
C        -----------------------------------------------------------------------
          CALL
     2    generateTestProgramPurposeMessage(  )
C        -----------------------------------------------------------------------
C
C         Create Output Of Title
C
C        -----------------------------------------------------------------------
          WRITE
     2     (
     3       STANDARD_OUTPUT,
     4       '( A )'
     5     )
     6     '',
     7     '',
     8     ''
C        -----------------------------------------------------------------------
          CALL
     2    generateTestProgramOutputHeader
     3      (
     4        specifiedFixedTrueGeocentricEastLongitudeDegrees
     5      )
C        -----------------------------------------------------------------------
           executionTimeOfTrialFunctionCallsMicroSeconds    = 0.0
C        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           CALL
     2     executeOneTrialConvertEcefToGeodetic
     3        (
     4          specifiedFixedTrueGeocentricEastLongitudeDegrees,
     5          executionTimeOfTrialFunctionCallsMicroSeconds,
     6          maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
     7          maximumGeodeticAltitudeAbsoluteErrorNanoMeters
     8        )
C        -----------------------------------------------------------------------
           totalTrialsExecutionTimeMicroSeconds =
     2                totalTrialsExecutionTimeMicroSeconds
     3                +
     4                executionTimeOfTrialFunctionCallsMicroSeconds
C        -----------------------------------------------------------------------
           maxTotalGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs
     2     =
     3     dmax1
     4     (
     5       maxTotalGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
     6       dabs
     7        ( maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs )
     8     )
C        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           maxTotalGeodeticAltitudeAbsoluteErrorNanoMeters
     2     =
     3     dmax1
     4     (
     5       maxTotalGeodeticAltitudeAbsoluteErrorNanoMeters,
     6       dabs
     7        ( maximumGeodeticAltitudeAbsoluteErrorNanoMeters )
     8     )
C        }----------------------------------------------------------------------
       END DO
C     --------------------------------------------------------------------------
       averageTrialExecutionTimeMicroSeconds =
     2       totalTrialsExecutionTimeMicroSeconds
     3       /
     4       numberTrials;
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '',
     7  '',
     8  ''
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '=============================================================',
     7  '==========================='
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  "|",
     7  "| AVERAGE TRIAL TIMING RESULTS:",
     8  "|"
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, I6, A )'
     5  )
     6  "|   Average execution time over ",
     7  numberTrials,
     8  " trial(s) of"
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, 0PES14.6, A )'
     5  )
     6  "|     'convertEcefToGeodetic' function calls:-->",
     7  averageTrialExecutionTimeMicroSeconds,
     8  " [microseconds]"
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  "|"
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '=============================================================',
     7  '==========================='
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '',
     7  '',
     8  ''
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '============================================',
     7  '============================================'
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|  MAXIMUM ABSOLUTE ERRORS OVER ALL TRIALS:',
     8  '|',
     9  '|    Maximum geodetic north latitude absolute error'
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, 0PF14.6, A )'
     5  )
     6  '|      over all trials is:-->',
     7   maxTotalGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
     8  ' [microarcseconds]'
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|    Maximum geodetic altitude absolute error'
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, 0PF14.6, A )'
     5  )
     6  '|      over all trials is:-->',
     7  maxTotalGeodeticAltitudeAbsoluteErrorNanoMeters,
     8  ' [nanometers]'
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6 '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6 '============================================',
     7 '============================================'
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '',
     7  '',
     8  ''
C     --------------------------------------------------------------------------
       STOP
C     --------------------------------------------------------------------------
       END
C===============================================================================
