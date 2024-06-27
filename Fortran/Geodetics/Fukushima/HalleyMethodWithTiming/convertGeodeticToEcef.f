       SUBROUTINE
     2 convertGeodeticToEcef
     3   (
     4     earthEquatorialRadiusMeters,
     5     earthEllipsoidalEccentricitySquared,
     6     geodeticNorthLatitudeRadians,
     7     geocentricEastLongitudeRadians,
     8     geodeticAltitudeMeters,
     9     xRectangularMeters,
     A     yRectangularMeters,
     B     zRectangularMeters
     C   )
C===============================================================================
C|
C|  FUNCTION:
C|
C|    convertGeodeticToEcef
C|
C|------------------------------------------------------------------------------
C|
C|  PURPOSE:
C|
C|    Convert:
C|      Specified Geodetic   North Latitude,
C|      Specified Geocentric East  Longitude
C|      Specified Geodetic         Altitude
C|    to ECEF rectangular coordinates.
C|
C|------------------------------------------------------------------------------
C|
C|  INPUTS:
C|
C|    earthEquatorialRadiusMeters
C|      Length of equatorial radius [meters].
C|      Also length of ellipsoid semi-major axis.
C|      Units:  [meters]
C|
C|    earthEllipsoidalEccentricitySquared
C|      Earth ellipsoid eccentricity squared.
C|      Units:  [nondimensional]
C|
C|    geodeticNorthLatitudeRadians
C|      The North geodetic latitude [radians]
C|      Northern hemisphere is positive.
C|      Units:  [radians]
C|
C|    geocentricEastLongitudeRadians
C|      The East Geocentric longitude [radians]
C|      Eastward is positive.
C|      Units:  [radians]
C|
C|    geodeticAltitudeMeters
C|      The geodetic altitude above the specified reference ellipsoid.
C|      [meters]
C|
C|------------------------------------------------------------------------------
C|
C|  OUTPUT:
C|
C|    xRectangularMeters
C|      The X Rectangular position [meters].
C|
C|    yRectangularMeters
C|      The Y Rectangular position [meters].
C|
C|    zRectangularMeters
C|      The Z Rectangular position [meters].
C|
C|------------------------------------------------------------------------------
C|
C|  RETURNED VALUE:
C|
C|    None.
C|
C|------------------------------------------------------------------------------
C|
C|  REFERENCE(s):
C|
C|    [ 1 ]  "Geographic coordinate conversion",
C|           "Coordinate system conversion",
C|           "From geodetic to ECEF coordinates"
C|           https://en.wikipedia.org/wiki/Geographic_coordinate_conversion
C|
C|    [ 2 ]  "Geometric Geodesy, Part A",
C|           "A set of lecture notes which are an introduction to
C|            ellipsoidal geometry related to geodesy.",
C|            R. E. Deakin and M. N. Hunter,
C|            School of Mathematical and Geospatial Sciences,
C|            RMIT University,
C|            Melbourne, Australia,
C|            January 2013
C|            www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
C|
C|------------------------------------------------------------------------------
C|
C|  USAGE:
C|
C|           xRectangularMeters = 0.0
C|           yRectangularMeters = 0.0
C|           zRectangularMeters = 0.0
C|    C- - - - - - - - - - - - - - - - - - - -
C|           CALL
C|         2 convertGeodeticToEcef
C|         3   (
C|         4     earthEquatorialRadiusMeters,
C|         5     earthEllipsoidalEccentricitySquared,
C|         6     geodeticNorthLatitudeRadians,
C|         7     geocentricEastLongitudeRadians,
C|         8     geodeticAltitudeMeters,
C|         9     xRectangularMeters,
C|         A     yRectangularMeters,
C|         B     zRectangularMeters
C|         C   )
C|
C===============================================================================

C===============================================================================
C        1         2         3         4         5         6         7         8
C2345678901234567890123456789012345678901234567890123456789012345678901234567890
C===============================================================================
       IMPLICIT   NONE
C     --------------------------------------------------------------------------
       REAL*8     earthEquatorialRadiusMeters
       REAL*8     earthEllipsoidalEccentricitySquared
       REAL*8     geodeticNorthLatitudeRadians
       REAL*8     geocentricEastLongitudeRadians
       REAL*8     geodeticAltitudeMeters
C     --------------------------------------------------------------------------
       REAL*8     xRectangularMeters
       REAL*8     yRectangularMeters
       REAL*8     zRectangularMeters
C     ==========================================================================
       REAL*8     invalidValue
C     --------------------------------------------------------------------------
       REAL*8       sineOfGeodeticNorthLatitude
       REAL*8     cosineOfGeodeticNorthLatitude
       REAL*8       sineOfGeocentricEastLongitude
       REAL*8     cosineOfGeocentricEastLongitude
       REAL*8     N
       REAL*8     rho
       REAL*8     rhoz
       REAL*8     r
C     --------------------------------------------------------------------------
       INTEGER*4  STANDARD_OUTPUT
C     --------------------------------------------------------------------------
       IF( earthEquatorialRadiusMeters .GT. 0.0 )
     2 THEN
C        {----------------------------------------------------------------------
C          Specified Earth equatorial radius is positive.
C        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C          Continue processing.
C        -----------------------------------------------------------------------
           IF( earthEllipsoidalEccentricitySquared .GT. 0.0 )
     2     THEN
C            {------------------------------------------------------------------
C              The specified Earth ellipsoidal eccentricity squared
C              is positive.
C            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C              Continue processing.
C            -------------------------------------------------------------------
                 sineOfGeodeticNorthLatitude    =
     2                 DSIN( geodeticNorthLatitudeRadians   )
               cosineOfGeodeticNorthLatitude    =
     2                 DCOS( geodeticNorthLatitudeRadians   )
C            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 sineOfGeocentricEastLongitude =
     2                 DSIN( geocentricEastLongitudeRadians )
               cosineOfGeocentricEastLongitude =
     2                 DCOS( geocentricEastLongitudeRadians )
C            -------------------------------------------------------------------
C 
C              NOTE(s):
C   
C                [ 1 ]  The value of the prime vertical radius of curvature, N,
C                       is derived in Equation (48) of Section 1.1.6
C                       "Geometry of the ellipse" pages 12 through 15 of
C                       Reference [2].
C   
C            -------------------------------------------------------------------
               N       = earthEquatorialRadiusMeters /
     2                   DSQRT
     3                    (
     4                      1.0D0 +
     5                      (
     6                        -earthEllipsoidalEccentricitySquared *
     7                         sineOfGeodeticNorthLatitude         *
     8                         sineOfGeodeticNorthLatitude
     9                      )
     A                    )
C            -------------------------------------------------------------------
               rho  = N + geodeticAltitudeMeters
               rhoz = (
     2                  ( 1.0D0 - earthEllipsoidalEccentricitySquared )
     3                  * 
     4                  N
     5                )
     6                +
     7                geodeticAltitudeMeters
C            -------------------------------------------------------------------
C              Check the length quantities.
C            -------------------------------------------------------------------
               IF(
     2             ( rho  .GT. 0.0D0 )
     3             .AND.
     4             ( rhoz .GT. 0.0D0 )
     5           )
     6         THEN
C                {--------------------------------------------------------------
C                  The length quantities are all positive.
C                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
C                  Continue the computation of ECEF retangular coordinates.
C    
C                  NOTE(s):
C
C                    [ 1 ]  The Earth Centered Earth Fixed (ECEF) coordinates
C                           { x, y, z } are computed via Equation (277) on
C                           on page 94, Section 2.1
C                           "Cartesian coords x,y,z given geodetic coords"
C                           of Reference [2].
C
C                    [ 2 ]  The Earth Centered Earth Fixed (ECEF) coordinates
C                           { x, y, z } are derived on pages 92, 93 and 94 of
C                           Chapter 2
C                           "Transformations Between Cartesian Coordinates
C                            x, y, z and Geodetic Coordinates"
C                           of Reference [2].
C
C                ---------------------------------------------------------------
                   r                  = rho  *
     2                                  cosineOfGeodeticNorthLatitude
C                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
                   xRectangularMeters = r    *
     2                                  cosineOfGeocentricEastLongitude
                   yRectangularMeters = r    *
     2                                    sineOfGeocentricEastLongitude
                   zRectangularMeters = rhoz *
     2                                    sineOfGeodeticNorthLatitude
C                }--------------------------------------------------------------
               ELSE
C                {--------------------------------------------------------------
C                  The length quantities are not all positive.
C                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
C                  Generate a purpose message.
C                ---------------------------------------------------------------
                   CALL
     2             generateConvertGeodeticToEcefPurposeMessage(  )
C                ---------------------------------------------------------------
C                  Generate a usage message.
C                ---------------------------------------------------------------
                   CALL
     2             generateConvertGeodeticToEcefUsageMessage(  )
C                ---------------------------------------------------------------
C                  Generate an error message.
C                ---------------------------------------------------------------
                   STANDARD_OUTPUT = 6
C                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
                   WRITE
     2              (
     3                STANDARD_OUTPUT,
     4                '( A )'
     5              )
     6              '',
     7              '',
     8              ''
C                ---------------------------------------------------------------
                   WRITE
     2              (
     3                STANDARD_OUTPUT,
     4                '( A, A )'
     5              )
     6              '================================================',
     7              '===================='
C                ---------------------------------------------------------------
                   WRITE
     2              (
     3                STANDARD_OUTPUT,
     4                '( A )'
     5              )
     6              '|',
     7              '|  ERROR:',
     8              '|',
     9              '|  SUBROUTINE:  convertGeodeticToEcef',
     A              '|',
     B              '|    The computed length quantities rho and rhoz',
     C              '|    are not both positive.',
     D              '|'
C                ---------------------------------------------------------------
                   WRITE
     2              (
     3                STANDARD_OUTPUT,
     4                '( A, 0PES14.6 )'
     5              )
     6              '|    Computed value for rho  is:-->',
     7              rho,
     8              '|    Computed value for rhoz is:-->',
     9              rhoz
C                ---------------------------------------------------------------
                   WRITE
     2              (
     3                STANDARD_OUTPUT,
     4                '( A )'
     5              )
     6              '|',
     7              '|    This is an error.',
     8              '|'
C                ---------------------------------------------------------------
                   WRITE
     2              (
     3                STANDARD_OUTPUT,
     4                '( A, A )'
     5              )
     6              '|===============================================',
     7              '===================='
C                ---------------------------------------------------------------
               WRITE
     2              (
     3                STANDARD_OUTPUT,
     4                '( A )'
     5              )
     6              '',
     7              '',
     8              ''
C                ---------------------------------------------------------------
C                  Assign invalid values to the output arguments.
C                ---------------------------------------------------------------
                   invalidValue       = 0.0D0
C                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
                   xRectangularMeters = invalidValue
                   yRectangularMeters = invalidValue
                   zRectangularMeters = invalidValue
C                }--------------------------------------------------------------
               ENDIF
C            }------------------------------------------------------------------
           ELSE
C            {------------------------------------------------------------------
C              The specified Earth ellipsoidal eccentricity squared
C              is not positive.
C              The specified Earth ellipsoidal eccentricity squared
C              is not valid.
C            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C              Generate a purpose message.
C            -------------------------------------------------------------------
               CALL
     2         generateConvertGeodeticToEcefPurposeMessage(  )
C            -------------------------------------------------------------------
C              Generate a usage message.
C            -------------------------------------------------------------------
               CALL
     2         generateConvertGeodeticToEcefUsageMessage(  )
C            -------------------------------------------------------------------
C              Generate an error message.
C            -------------------------------------------------------------------
               STANDARD_OUTPUT = 6
C             - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               WRITE
     2          (
     3            STANDARD_OUTPUT,
     4            '( A )'
     5          )
     6          '',
     7          '',
     8          ''
C            -------------------------------------------------------------------
               WRITE
     2          (
     3            STANDARD_OUTPUT,
     4            '( A, A )'
     5          )
     6          '====================================================',
     7          '================'
C            -------------------------------------------------------------------
               WRITE
     2          (
     3            STANDARD_OUTPUT,
     4            '( A )'
     5          )
     6          '|',
     7          '|  ERROR:',
     8          '|',
     9          '|  SUBROUTINE:  convertGeodeticToEcef',
     A          '|',
     B          '|    The specified Earth ellipsoidal eccentricity',
     C          '|    squared value is invalid.',
     D          '|',
     E          '|    The specified Earth ellipsoidal eccentricity',
     F          '|    squared value expected to be strictly positive.',
     G          '|',
     H          '|    Specified Earth ellipsoidal eccentricity'
C            -------------------------------------------------------------------
                   WRITE
     2          (
     3            STANDARD_OUTPUT,
     4            '( A, 0PES14.6 )'
     5          )
     8          '|    squared value is:-->',
     9          earthEllipsoidalEccentricitySquared
C            -------------------------------------------------------------------
               WRITE
     2          (
     3            STANDARD_OUTPUT,
     4            '( A )'
     5          )
     6          '|',
     7          '|    This is an error.',
     8          '|'
C            -------------------------------------------------------------------
               WRITE
     2          (
     3            STANDARD_OUTPUT,
     4            '( A, A )'
     5          )
     6          '|===================================================',
     7          '================'
C            -------------------------------------------------------------------
               WRITE
     2              (
     3                STANDARD_OUTPUT,
     4                '( A )'
     5              )
     6              '',
     7              '',
     8              ''
C            -------------------------------------------------------------------
C              Assign invalid values to the output arguments.
C            -------------------------------------------------------------------
               invalidValue       = 0.0D0
C             - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               xRectangularMeters = invalidValue
               yRectangularMeters = invalidValue
               zRectangularMeters = invalidValue
C            }------------------------------------------------------------------
           ENDIF
C        }----------------------------------------------------------------------
       ELSE
C        {----------------------------------------------------------------------
C          Specified Earth equatorial radius is not positive.
C          Specified Earth equatorial radius is not valid.
C        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C          Generate a purpose message.
C        -----------------------------------------------------------------------
           CALL
     2     generateConvertGeodeticToEcefPurposeMessage(  )
C        -----------------------------------------------------------------------
C          Generate a usage message.
C        -----------------------------------------------------------------------
           CALL
     2     generateConvertGeodeticToEcefUsageMessage(  )
C        -----------------------------------------------------------------------
C          Generate an error message.
C        -----------------------------------------------------------------------
           STANDARD_OUTPUT = 6
C         - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           WRITE
     2      (
     3        STANDARD_OUTPUT,
     4        '( A )'
     5      )
     6      '',
     7      '',
     8      ''
C     --------------------------------------------------------------------------
           WRITE
     2      (
     3        STANDARD_OUTPUT,
     4        '( A, A )'
     5      )
     6      '========================================================',
     7      '============'
C     --------------------------------------------------------------------------
           WRITE
     2      (
     3        STANDARD_OUTPUT,
     4        '( A )'
     5      )
     6      '|',
     7      '|  ERROR:',
     8      '|',
     9      '|  SUBROUTINE:  convertGeodeticToEcef',
     A      '|',
     B      '|    The specified Earth equatorial radius is not',
     C      '|    valid.',
     D      '|',
     E      '|    The specified Earth equatorial radius is',
     F      '|    expected to be strictly positive.',
     G      '|',
     6      '|    Specified Earth equatorial radius value'
C     --------------------------------------------------------------------------
           WRITE
     2      (
     3        STANDARD_OUTPUT,
     4        '( A, 0PES14.6 )'
     5      )
     8      '|    is:-->',
     9      earthEquatorialRadiusMeters
C     --------------------------------------------------------------------------
           WRITE
     2      (
     3        STANDARD_OUTPUT,
     4        '( A )'
     5      )
     6      '|',
     7      '|    This is an error.',
     8      '|'
C     --------------------------------------------------------------------------
           WRITE
     2      (
     3        STANDARD_OUTPUT,
     4        '( A, A )'
     5      )
     6      '|=======================================================',
     7      '============'
C     --------------------------------------------------------------------------
           WRITE
     2          (
     3            STANDARD_OUTPUT,
     4            '( A )'
     5          )
     6          '',
     7          '',
     8          ''
C        -----------------------------------------------------------------------
C          Assign invalid values to the output arguments.
C        -----------------------------------------------------------------------
           invalidValue       = 0.0D0
C         - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           xRectangularMeters = invalidValue
           yRectangularMeters = invalidValue
           zRectangularMeters = invalidValue
C        }----------------------------------------------------------------------
       ENDIF
C     --------------------------------------------------------------------------
C     --------------------------------------------------------------------------
       RETURN
C     --------------------------------------------------------------------------
       END
C===============================================================================
