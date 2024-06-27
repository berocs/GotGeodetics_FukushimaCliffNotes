C===============================================================================
C        1         2         3         4         5         6         7         8
C2345678901234567890123456789012345678901234567890123456789012345678901234567890
C===============================================================================
       PROGRAM
     2 testConvertEcefToGeodetic
C-------------------------------------------------------------------------------
C
C   MAIN PROGRAM:
C
C     testConvertEcefToGeodetic 
C 
C-------------------------------------------------------------------------------
C
C   PURPOSE:
C 
C     To test the conversion of specified ECEF retangular coordinates
C     to geodetic coordinates for a specified reference ellipsoid.
C 
C-------------------------------------------------------------------------------
C 
C   METHOD:
C 
C     [ 1 ] Uses the economic third-order Halley's method to solve the
C           general non-linear fourth-order algebraic geodetic equation
C           numerically.
C 
C     [ 2 ] Uses only  one iteration of the iterative Halley's method
C           to achieve near double precision accuracy.
C 
C     [ 3 ] Uses a technique to avoid division operations which significantly
C           accelerates the backward transformation without degrading the
C           precision.
C 
C-------------------------------------------------------------------------------
C 
C   AUTHOR(s):
C 
C     [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
C            National Astronomical Observatory of Japan (NAOJ)
C            Address:  2-21-1, Ohsawa, Mitaka, Tokyo   181-8588,  Japan
C            Phone:    +81-422-34-3613
C 
C-------------------------------------------------------------------------------
C 
C   REFERENCE(s):
C 
C      [ 1 ]  "Transformation from Cartesian to geodetic
C              coordinates accelerated by Halley's method",
C             Toshio Fukushima,
C             J.Geodesy (2006),
C             Volume 79,
C             Pages 689-693
C 
C      [ 2 ]  "Fast transform from geocentric to geodetic coordinates",
C             Toshio Fukushima,
C             Journal Of Geodesy (1999),
C             Volume 73,
C             Pages 603–610
C 
C      [ 3 ]  "Geometric Geodesy, Part A",
C             "A set of lecture notes which are an introduction to
C              ellipsoidal geometry related to geodesy.",
C              R. E. Deakin and M. N. Hunter,
C              School of Mathematical and Geospatial Sciences,
C              RMIT University,
C              Melbourne, Australia,
C              January 2013
C              www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
C 
C      [ 4 ]  'Various parameterizations of "latitude" equation -
C              Cartesian to geodetic coordinates transformation',
C              Marcin Ligas,
C              Journal of Geodetic Science,
C              Pages 87 - 94,
C              2013
C 
C      [ 5 ]  "In numerical analysis, Halley's method is a root-finding
C              algorithm used for functions of one real variable with a
C              continuous second derivative.",
C             "The rate of convergence of the iterative Halley's method
C              is cubic.",
C             "There exist multidimensional versions of Halley's method.",
C             wikipedia.org/wiki/Halley's_method`
C
C-------------------------------------------------------------------------------
       IMPLICIT   NONE
C-------------------------------------------------------------------------------
       INTEGER*4  latitudeIndex
       INTEGER*4  altitudeIndex
       INTEGER*4  minimumLatitudeIndex
       INTEGER*4  maximumLatitudeIndex
       INTEGER*4  minimumAltitudeIndex
       INTEGER*4  maximumAltitudeIndex
C     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       INTEGER*4  STANDARD_OUTPUT
C     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       REAL*8     deltaGeodeticLatitudeDegrees
       REAL*8     deltaGeodeticAltitudeMeters
       REAL*8     minimumTrueGeodeticNorthLatitudeDegrees
       REAL*8     maximumTrueGeodeticNorthLatitudeDegrees
C     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       REAL*8     PI
       REAL*8     radiansPerDegree
       REAL*8     degreesPerRadian
       REAL*8     arcMinutesPerDegree
       REAL*8     arcSecondsPerArcMinute
       REAL*8     arcSecondsPerDegree
       REAL*8     microArcSecondsPerArcSecond
       REAL*8     microArcSecondsPerDegree
       REAL*8     microArcSecondsPerRadian
       REAL*8     nanoMetersPerMeter
       REAL*8     earthEquatorialRadiusMeters
       REAL*8     inverseEarthEllipsoidalFlatteningFactor
       REAL*8     earthEllipsoidalFlatteningFactor
C     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       REAL*8     earthEllipsoidalEccentricitySquared
       REAL*8     trueGeocentricEastLongitudeDegrees
       REAL*8     trueGeocentricEastLongitudeRadians
       REAL*8     trueGeodeticNorthLatitudeDegrees
       REAL*8     trueGeodeticNorthLatitudeRadians
       REAL*8     trueGeodeticAltitudeMeters
       REAL*8     xTrueRectangularMeters
       REAL*8     yTrueRectangularMeters
       REAL*8     zTrueRectangularMeters
       REAL*8     estimatedGeocentricEastLongitudeRadians
       REAL*8     estimatedGeodeticNorthLatitudeRadians
       REAL*8     estimatedGeodeticAltitudeMeters
       REAL*8     geodeticAltitudeErrorMeters
       REAL*8     geodeticAltitudeErrorNanoMeters
       REAL*8     geodeticLatitudeErrorRadians
       REAL*8     geodeticLatitudeErrorMicroArcSeconds
       REAL*8     maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs
       REAL*8     maximumGeodeticAltitudeAbsoluteErrorNanoMeters
C-------------------------------------------------------------------------------
       STANDARD_OUTPUT             = 6
C     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       PI                          = 4.0D0   * DATAN( 1.0D0 )
       radiansPerDegree            = PI      /  180.0D0
       degreesPerRadian            = 180.0D0 /  PI
C     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       arcMinutesPerDegree         =  60.0D0
       arcSecondsPerArcMinute      =  60.0D0
       nanoMetersPerMeter          =   1.0D9
       microArcSecondsPerArcSecond =   1.0D6
       arcSecondsPerDegree         =  arcSecondsPerArcMinute      *
     2                                arcMinutesPerDegree
       microArcSecondsPerDegree    =  microArcSecondsPerArcSecond *
     2                                arcSecondsPerDegree
       microArcSecondsPerRadian    =  microArcSecondsPerDegree    *
     3                                degreesPerRadian
C     --------------------------------------------------------------------------
C
C      The parameters:
C        [ 1 ]  Earth equatorial radius [meters]
C        [ 2 ]  Inverse Earth ellipsoidal flattening factor
C      are set to the GRS1980 System values.
C
C     --------------------------------------------------------------------------
       earthEquatorialRadiusMeters             = 6378137.0D0
       inverseEarthEllipsoidalFlatteningFactor =     298.257222101D0
C     --------------------------------------------------------------------------
       maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs = 0.0D0
       maximumGeodeticAltitudeAbsoluteErrorNanoMeters        = 0.0D0
C     --------------------------------------------------------------------------
       earthEllipsoidalFlatteningFactor        =
     2                           1.0D0 /
     3                           inverseEarthEllipsoidalFlatteningFactor
C     --------------------------------------------------------------------------
C
C      STRATEGY:
C
C        [ 1 ]  Define true geodetic latitude and altitude
C               values along the 45-degree East geocentric
C               longitude meridian.
C
C        [ 2 ]  Generate true rectangular values based on the
C               true geodetic latitude, true geodetic altitude
C               and constant geocentric longitude values.
C
C        [ 3 ]  Compute estimated geodetic values based on the
C               true rectangular values.
C
C        [ 4 ]  Report the differences between the defined true
C               geodetic values and the estimated geodetic
C               values.
C
C     --------------------------------------------------------------------------
       earthEllipsoidalEccentricitySquared     =
     2                 ( 2.0D0 - earthEllipsoidalFlatteningFactor ) *
     3                           earthEllipsoidalFlatteningFactor
C     --------------------------------------------------------------------------
       CALL
     2 generateTestProgramPurposeMessage(  )
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
C
C      Fix the true longitude at 45 degrees East for test purposes.
C
C     --------------------------------------------------------------------------
       trueGeocentricEastLongitudeDegrees      = 45.0D0
C     --------------------------------------------------------------------------
       minimumTrueGeodeticNorthLatitudeDegrees =  1.0D-9
       maximumTrueGeodeticNorthLatitudeDegrees = 89.999999999D0
C     --------------------------------------------------------------------------
       CALL
     2 generateTestProgramOutputHeader
     3   (
     4     trueGeocentricEastLongitudeDegrees
     5   )
C     --------------------------------------------------------------------------
       trueGeocentricEastLongitudeRadians =
     2                            radiansPerDegree *
     3                            trueGeocentricEastLongitudeDegrees
C     --------------------------------------------------------------------------
       deltaGeodeticLatitudeDegrees = 15.0D+0
       deltaGeodeticAltitudeMeters  =  1.0D+6
C     --------------------------------------------------------------------------
       minimumAltitudeIndex         =   0;
       maximumAltitudeIndex         =   3;
       minimumLatitudeIndex         =  -1;
       maximumLatitudeIndex         =   6;
C     --------------------------------------------------------------------------
C
C      Loop for true Latitude values.
C      (You may increase the number of test data set)
C
C     --------------------------------------------------------------------------
       DO  latitudeIndex = minimumLatitudeIndex,
     2                     maximumLatitudeIndex
C         {---------------------------------------------------------------------
           trueGeodeticNorthLatitudeDegrees =
     2                              DBLE( latitudeIndex ) *
     3                              deltaGeodeticLatitudeDegrees
C         ----------------------------------------------------------------------
C
C          Include Near-Equator/Polar Cases
C
C         ----------------------------------------------------------------------
           trueGeodeticNorthLatitudeDegrees =
     2              MIN(
     3                   maximumTrueGeodeticNorthLatitudeDegrees,
     4                   MAX(
     5                        trueGeodeticNorthLatitudeDegrees,
     6                        minimumTrueGeodeticNorthLatitudeDegrees
     7                      )
     8                 )
C         ----------------------------------------------------------------------
           trueGeodeticNorthLatitudeRadians =
     2                              radiansPerDegree *
     3                              trueGeodeticNorthLatitudeDegrees
C         ----------------------------------------------------------------------
C
C          Loop for true Altitude values.
C          (You may increase the number of test data set)
C
C         ----------------------------------------------------------------------
           DO  altitudeIndex = minimumAltitudeIndex,
     2                         maximumAltitudeIndex
C             {-----------------------------------------------------------------
               IF( altitudeIndex .EQ. 0 )
     2         THEN
C                {--------------------------------------------------------------
                   trueGeodeticAltitudeMeters = -1.0D4
C                }--------------------------------------------------------------
               ELSE
C                {--------------------------------------------------------------
                   trueGeodeticAltitudeMeters =
     2                                 DBLE( altitudeIndex )
     3                                 *
     4                                 deltaGeodeticAltitudeMeters
C                }--------------------------------------------------------------
               ENDIF
C             ------------------------------------------------------------------
C              Generate true rectagular values based on the defined true
C              geodetic values.
C             ------------------------------------------------------------------
               xTrueRectangularMeters = 0.0D0
               yTrueRectangularMeters = 0.0D0
               zTrueRectangularMeters = 0.0D0
C             - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               CALL
     2         convertGeodeticToEcef
     3                (
     4                  earthEquatorialRadiusMeters,
     5                  earthEllipsoidalEccentricitySquared,
     6                  trueGeodeticNorthLatitudeRadians,
     7                  trueGeocentricEastLongitudeRadians,
     8                  trueGeodeticAltitudeMeters,
     9                  xTrueRectangularMeters,
     A                  yTrueRectangularMeters,
     B                  zTrueRectangularMeters
     C                )
C             ------------------------------------------------------------------
C
C              Estimate the geodetic values based on the true rectangular
C              coordinate values using Halley's third order method
C
C              (applying only for one iteration to obtain desired double
C               precision accuracy)
C
C             ------------------------------------------------------------------
               estimatedGeodeticNorthLatitudeRadians   = 0.0D0
               estimatedGeocentricEastLongitudeRadians = 0.0D0
               estimatedGeodeticAltitudeMeters         = 0.0D0
C             - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               CALL
     2         convertEcefToGeodetic
     3           (
     4             earthEquatorialRadiusMeters,
     5             earthEllipsoidalFlatteningFactor,
     6             xTrueRectangularMeters,
     7             yTrueRectangularMeters,
     8             zTrueRectangularMeters,
     9             estimatedGeodeticNorthLatitudeRadians,
     A             estimatedGeocentricEastLongitudeRadians,
     B             estimatedGeodeticAltitudeMeters
     C           )
C             ------------------------------------------------------------------
C
C              Generate the error residuals
C
C             ------------------------------------------------------------------
               geodeticLatitudeErrorRadians =
     2                      trueGeodeticNorthLatitudeRadians -
     3                 estimatedGeodeticNorthLatitudeRadians
               geodeticLatitudeErrorMicroArcSeconds =
     2                 microArcSecondsPerRadian      *
     3                 geodeticLatitudeErrorRadians
C             - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               geodeticAltitudeErrorMeters =
     2                 trueGeodeticAltitudeMeters -
     3                 estimatedGeodeticAltitudeMeters
               geodeticAltitudeErrorNanoMeters =
     2                 nanoMetersPerMeter          *
     3                 geodeticAltitudeErrorMeters
C             ------------------------------------------------------------------
               maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs
     2         =
     3         dmax1
     4          (
     5            maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
     6            dabs( geodeticLatitudeErrorMicroArcSeconds )
     7          )
C             - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               maximumGeodeticAltitudeAbsoluteErrorNanoMeters
     2         =
     3         dmax1
     4          (
     5            maximumGeodeticAltitudeAbsoluteErrorNanoMeters,
     6            dabs( geodeticAltitudeErrorNanoMeters )
     7          )
C             ------------------------------------------------------------------
C              Generate a report.
C             ------------------------------------------------------------------
               WRITE
     2           (
     3             STANDARD_OUTPUT,
     4             '( 3X, 0PF16.10,  0PF18.5, 0PES22.10, 0PES22.10  )'
     5           )
     6           trueGeodeticNorthLatitudeDegrees,
     7           trueGeodeticAltitudeMeters,
     8           geodeticLatitudeErrorMicroArcSeconds,
     9           geodeticAltitudeErrorNanoMeters
C             ------------------------------------------------------------------
C              End of Altitude loop.
C             }-----------------------------------------------------------------
           END DO
C         ----------------------------------------------------------------------
C          End of Latitude loop.
C         }---------------------------------------------------------------------
       END DO
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '=============================================================',
     7  '==========================='
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
     7  '|  MAXIMUM ABSOLUTE ERRORS OVER ONE TRIAL:',
     8  '|',
     9  '|    Maximum geodetic north latitude absolute error'
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, 0PF14.6, A )'
     5  )
     6  '|      is:-->',
     7   maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
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
     6  '|      is:-->',
     7  maximumGeodeticAltitudeAbsoluteErrorNanoMeters,
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
