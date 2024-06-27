       SUBROUTINE
     2 convertEcefToGeodetic
     3   (
     4     earthEquatorialRadiusMeters,
     5     earthEllipsoidalFlatteningFactor,
     6     xRectangularMeters,
     7     yRectangularMeters,
     8     zRectangularMeters,
     9     estimatedGeodeticNorthLatitudeRadians,
     A     estimatedGeocentricEastLongitudeRadians,
     B     estimatedGeodeticAltitudeMeters
     C   )
C===============================================================================
C|
C|  SUBROUTINE:
C|
C|    convertEcefToGeodetic
C|
C|-----------------------------------------------------------------------------
C|
C|  PURPOSE:
C|
C|    A Fortran subroutine to convert geocentric rectangular coordinates
C|    to geodetic coordinates by applying Halley's iterative method using
C|    only one iteration to achieve full double precision precision accuracy.
C|
C|-----------------------------------------------------------------------------
C|
C|  METHOD:
C|
C|    [ 1 ] Uses the economic third-order Halley's method to approximate
C|          a solution for the general non-linear geodetic equation
C|          numerically.
C|
C|    [ 2 ] Uses only  one iteration of the iterative Halley's method
C|          to achieve near double precision accuracy.
C|
C|    [ 3 ] Uses a technique to avoid division operations which significantly
C|          accelerates the backward transformation without degrading the
C|          precision.
C|
C|-----------------------------------------------------------------------------
C|
C|  INPUTS:
C}
C|    earthEquatorialRadiusMeters
C|      Length of Earth equatorial radius
C|      Also length of Earth ellipsoid semi-major axis.
C|      Units:  [meters]
C|
C|    earthEllipsoidalFlatteningFactor
C|      Value of Earth ellipsoidal flattening factor, f.
C|      Units:  [nondimensional]
C|
C|    xRectangularMeters
C|      Rectangular X coordinate value.
C|      UNITS:  [meters]
C}
C|    yRectangularMeters
C|      Rectangular Y coordinate value.
C|      UNITS:  [meters]
C}
C|    zRectangularMeters
C|      Rectangular Z coordinate value.
C|      UNITS:  [meters]
C|
C|-----------------------------------------------------------------------------
C|
C|  OUTPUTS:
C|
C|    estimatedGeodeticNorthLatitudeRadians
C|      Estimated North Geodetic   latitude.
C|      UNITS:  [radians]
C|
C|    estimatedGeocentricEastLongitudeRadians
C|      Estimated East Geocentric longitude.
C|      UNITS:  [radians]
C|
C|    estimatedGeodeticAltitudeMeters
C|      Estimated Geodetic   altitude.
C|      UNITS:  [meters]
C|
C|-----------------------------------------------------------------------------
C|
C|  NOTE(s):
C|
C|    [ 1 ] This function is based on the FORTRAN subroutine gconv2h by
C|          Toshio Fukushima (see reference).
C|
C|------------------------------------------------------------------------------
C|
C|  AUTHOR(s):
C|
C|     [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
C|            National Astronomical Observatory of Japan (NAOJ)
C|            Address:  2-21-1, Ohsawa, Mitaka, Tokyo   181-8588,  Japan
C|            Phone:    +81-422-34-3613
C|
C|------------------------------------------------------------------------------
C|
C|  REFERENCE(s):
C|
C|    [ 1 ]  "Transformation from Cartestian to Geodetic Coordinates
C|            Accelerated by Halley's Method",
C|           Toshio Fukushima
C|           2006, Journal of Geodesy,
C|           Volume 79
C|           Pages 689-693
C|
C|    [ 2 ]  "Fast transform from geocentric to geodetic coordinates",
C|           Toshio Fukushima,
C|           Journal Of Geodesy (1999),
C|           Volume 73,
C|           Pages 603–610
C|
C|    [ 3 ]  "Geometric Geodesy, Part A",
C|           "A set of lecture notes which are an introduction to
C|            ellipsoidal geometry related to geodesy.",
C|            R. E. Deakin and M. N. Hunter,
C|            School of Mathematical and Geospatial Sciences,
C|            RMIT University,
C|            Melbourne, Australia,
C|            January 2013
C|            www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
C|
C|    [ 4 ]  'Various parameterizations of "latitude" equation -
C|            Cartesian to geodetic coordinates transformation',
C|            Marcin Ligas,
C|            Journal of Geodetic Science,
C|            Pages 87 - 94,
C|            2013
C|
C|    [ 5 ]  "In numerical analysis, Halley's method is a root-finding
C|            algorithm used for functions of one real variable with a
C|            continuous second derivative.",
C|           "The rate of convergence of the iterative Halley's method
C|            is cubic.",
C|           "There exist multidimensional versions of Halley's method.",
C|           wikipedia.org/wiki/Halley's_method`
C|
C===============================================================================

C===============================================================================
C        1         2         3         4         5         6         7         8
C2345678901234567890123456789012345678901234567890123456789012345678901234567890
C===============================================================================

C{------------------------------------------------------------------------------
       IMPLICIT   NONE
C===============================================================================
       REAL*8     earthEquatorialRadiusMeters
       REAL*8     earthEllipsoidalFlatteningFactor
       REAL*8     xRectangularMeters
       REAL*8     yRectangularMeters
       REAL*8     zRectangularMeters
       REAL*8     estimatedGeodeticNorthLatitudeRadians
       REAL*8     estimatedGeocentricEastLongitudeRadians
       REAL*8     estimatedGeodeticAltitudeMeters
C===============================================================================
       REAL*8     earthEquatorialRadiusInverse
       REAL*8     eps
       REAL*8     aEps
       REAL*8     aEpsSquared
       REAL*8     earthEllipticitySquared
       REAL*8     earthEllipticityFourth
       REAL*8     oneAndHalfEarthEllipticityFourth
       REAL*8     complimentaryEarthEllipticitySquared
       REAL*8     complimentaryEarthEllipticity
       REAL*8     earthPolarRadiusMeters
       REAL*8     halfPi
C     --------------------------------------------------------------------------
       REAL*8     absZ
       REAL*8     earthPolarAxisDistanceSquared
       REAL*8     earthPolarAxisDistanceMeters
       REAL*8     s0
       REAL*8     pn
       REAL*8     zc
       REAL*8     c0
       REAL*8     c0Squared
       REAL*8     c0Cubed
       REAL*8     s0Squared
       REAL*8     s0Cubed
       REAL*8     a0Squared
       REAL*8     a0
       REAL*8     a0Cubed
       REAL*8     d0
       REAL*8     f0
       REAL*8     b0
       REAL*8     s1
       REAL*8     c1
       REAL*8     cc
       REAL*8     a1
       REAL*8     s1Squared
       REAL*8     ccSquared
       REAL*8     invalidValue
C     --------------------------------------------------------------------------
       INTEGER*4  STANDARD_OUTPUT
C     --------------------------------------------------------------------------
       IF(
     2      ( earthEllipsoidalFlatteningFactor .GE. 0.0 )
     3      .AND.
     4      ( earthEllipsoidalFlatteningFactor .LT. 1.0 )
     5   )
     6 THEN
C        {----------------------------------------------------------------------
C          The specified Earth ellipsoidal flattening factor is valid.
C         - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C          Continue validating the specified Earth ellipsoidal parameters.
C        -----------------------------------------------------------------------
           IF( earthEquatorialRadiusMeters .GT. 0.0 )
     2     THEN
C            {------------------------------------------------------------------
C              The specified Earth equatorial radius value is valid.
C            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C              Determine functions of the ellipsoid parameters.
C            -------------------------------------------------------------------
               earthEquatorialRadiusInverse         =
     2                  1.0D0 /
     3                  earthEquatorialRadiusMeters
               eps                                  = 1.0D-16
               aEps                                 =
     2                  earthEquatorialRadiusMeters *
     3                  eps
               aEpsSquared                          = aEps * aEps
C            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               earthEllipticitySquared              =
     2                  ( 2.0D0 -
     3                    earthEllipsoidalFlatteningFactor ) *
     4                    earthEllipsoidalFlatteningFactor
               earthEllipticityFourth               =
     2                            earthEllipticitySquared *
     3                            earthEllipticitySquared
               oneAndHalfEarthEllipticityFourth     =
     2                                    1.5D0 *
     3                                    earthEllipticityFourth
               complimentaryEarthEllipticitySquared =
     2                            1.0D0 -
     3                            earthEllipticitySquared
C            -------------------------------------------------------------------
C              NOTE:
C
C                The fact that the ellipsoidal flattening factor parameter is
C                valid guarantees that the squared complementary ellipsoidal
C                parameter value ecSquared is strictly positive.
C                We will check the the ecSquared value is strictly positive
C                here anyway.
C
C            -------------------------------------------------------------------
               IF( complimentaryEarthEllipticitySquared .GT. 0.0 )
     2         THEN
C                {--------------------------------------------------------------
C                  The complementary Earth ellipticity squared value is valid.
C                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C                  Continue ECEF to geodetic conversion processing.
C                ---------------------------------------------------------------
                   complimentaryEarthEllipticity =
     2                  DSQRT( complimentaryEarthEllipticitySquared )
                   earthPolarRadiusMeters        =
     2                                    complimentaryEarthEllipticity
     3                                    *
     4                                    earthEquatorialRadiusMeters
                   halfPi                        = 2.0D0 *
     2                                             DATAN( 1.0D0 )
C                ---------------------------------------------------------------
C
C                  Distance from Polar Axis:
C
C                ---------------------------------------------------------------
                   earthPolarAxisDistanceSquared = (
     2                                               xRectangularMeters
     3                                               *
     4                                               xRectangularMeters
     5                                             )
     6                                             +
     7                                             (
     8                                               yRectangularMeters
     9                                               *
     A                                               yRectangularMeters
     B                                             )
C                ---------------------------------------------------------------
C
C                  Geocentric Longitude
C
C                ---------------------------------------------------------------
                   estimatedGeocentricEastLongitudeRadians =
     2                                DATAN2(
     3                                        yRectangularMeters,
     4                                        xRectangularMeters
     5                                      )
C                ---------------------------------------------------------------
C
C                  Unsigned Geocentric Z-coordinate
C
C                ---------------------------------------------------------------
                   absZ = abs( zRectangularMeters )
C                ---------------------------------------------------------------
                   IF( earthPolarAxisDistanceSquared .GT. aEpsSquared )
     2             THEN
C                    {----------------------------------------------------------
C                      The specified Geocentric coordinates are sufficiently
C                      far from the Earth polar axis for normal geodetic
C                      processing.
C                    - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C                      Determine distance from the Earth polar axis.
C                    -----------------------------------------------------------
                       earthPolarAxisDistanceMeters  =
     2                      DSQRT( earthPolarAxisDistanceSquared )
C                    -----------------------------------------------------------
C
C                      Perform normalization.
C
C                    -----------------------------------------------------------
C                      This is from Equation (2)  on Page 690 and
C                                   Equation (17) on Page 691 of
C                      Reference [ 1 ].
C                      Here the factor of ec in Equation (2) is missing.
C                    -----------------------------------------------------------
                       s0      = absZ *
     2                           earthEquatorialRadiusInverse
C                    -----------------------------------------------------------
C                      This is Equation (2) on Page 690 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       pn      = earthPolarAxisDistanceMeters  *
     2                           earthEquatorialRadiusInverse
                       zc      = complimentaryEarthEllipticity * s0

C                    ===========================================================
C
C                      Prepare Newton Correction Factors.
C
C                    ===========================================================

C                    -----------------------------------------------------------
C                      This is Equation (17) on Page 691 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       c0        = complimentaryEarthEllipticity  * pn
C                    -----------------------------------------------------------
                       c0Squared = c0  * c0
                       c0Cubed   = c0  * c0Squared
C                    -----------------------------------------------------------
                       s0Squared = s0 * s0
                       s0Cubed   = s0 * s0Squared
C                    -----------------------------------------------------------
C                      This is Equation (14) on Page 690 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       a0Squared = c0Squared + s0Squared
                       a0        = DSQRT( a0Squared )
                       a0Cubed   = a0 * a0Squared
C                    -----------------------------------------------------------
C                      This is Equation (12) on Page 690 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       d0  = (  zc                      * a0Cubed ) +
     2                       (  earthEllipticitySquared * s0Cubed )
C                    -----------------------------------------------------------
C                      This is Equation (13) on Page 690 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       f0  = (  pn                      * a0Cubed ) +
     2                       ( -earthEllipticitySquared * c0Cubed )

C                    ===========================================================
C
C                      Prepare Halley Correction Factors.
C
C                    ===========================================================

C                    -----------------------------------------------------------
C                      This is Equation (15) on Page 690 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       b0    = oneAndHalfEarthEllipticityFourth       *
     2                         s0Squared                              *
     3                         c0Squared                              *
     4                         pn                                     *
     5                         ( a0 - complimentaryEarthEllipticity )
C                    -----------------------------------------------------------
C                      This is Equation (10) on Page 690 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       s1  =   ( d0 * f0 ) + ( -b0 * s0 )
C                    -----------------------------------------------------------
C                      This is Equation (11) on Page 690 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       c1  =   ( f0 * f0 ) + ( -b0 * c0 )
C                    -----------------------------------------------------------
C                      This is Equation (21) on Page 691 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       cc  = complimentaryEarthEllipticity * c1

C                    ===========================================================
C
C                      Evaluate geodetic latitude.
C
C                    ===========================================================

C                    -----------------------------------------------------------
C                      This is Equation (19) on Page 691 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       estimatedGeodeticNorthLatitudeRadians =
     2                                               DATAN2( s1, cc )

C                    ===========================================================
C
C                      Evaluate geodetic altitude.
C
C                    ===========================================================

C                    -----------------------------------------------------------
                       s1Squared        = s1 * s1
                       ccSquared        = cc * cc
C                    -----------------------------------------------------------
C                      The quantity a1 is ec times A1.
C                      The quantity A1 is given by Equation (14) on
C                      Page 690 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       a1  =
     2                    DSQRT(
     3                           (
     4                            complimentaryEarthEllipticitySquared
     5                            *
     6                            s1Squared
     7                          )
     8                          +
     9                          ccSquared
     A                        )
C                    -----------------------------------------------------------
C                      This is Equation (20) on Page 691 of Reference [ 1 ].
C                    -----------------------------------------------------------
                       estimatedGeodeticAltitudeMeters =
     2                      (
     3                        (
     4                          ( earthPolarAxisDistanceMeters * cc )
     5                          +
     6                          ( absZ                         * s1 )
     7                        )
     8                        +
     9                        (
     A                          -earthEquatorialRadiusMeters *
     B                           a1
     C                        )
     D                      ) / DSQRT( s1Squared + ccSquared )
C                    }----------------------------------------------------------
                   ELSE
C                    {----------------------------------------------------------
C                      The specified Geocentric coordinates are very near the
C                      Earth polar axis.
C                    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C                      Apply exceptional processing for the Earth polar axis
C                      vicinity.
C                    -----------------------------------------------------------
                       estimatedGeodeticNorthLatitudeRadians = halfPi
                       estimatedGeodeticAltitudeMeters       =
     2                                        absZ -
     3                                        earthPolarRadiusMeters
C                    }----------------------------------------------------------
                   ENDIF
C                ===============================================================
C
C                  Post-process
C
C                ===============================================================
                   IF( zRectangularMeters .LT. 0.0D0 )
     2             THEN
C                    {----------------------------------------------------------
C                      The specified z rectangular coordinate is negative.
C                    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C                      In the Southern Hemisphere.
C                    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C                      Reverse the sign of the geodetic latitude.
C                    -----------------------------------------------------------
                       estimatedGeodeticNorthLatitudeRadians =
     2                         -estimatedGeodeticNorthLatitudeRadians
C                    }----------------------------------------------------------
                   ENDIF
C                }--------------------------------------------------------------
               ELSE
C                {--------------------------------------------------------------
C                  The complementary Earth ellipticity squared value is invalid.
C                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C                  Generate a purpose message.
C                ---------------------------------------------------------------
                   CALL
     2             generateConvertEcefToGeodeticPurposeMessage(  )
C                ---------------------------------------------------------------
C                  Generate an usage message.
C                ---------------------------------------------------------------
                   CALL
     2             generateConvertEcefToGeodeticUsageMessage(  )
C                ---------------------------------------------------------------
C                  Generate an error message.
C                ---------------------------------------------------------------
                   STANDARD_OUTPUT = 6
C                - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
     9              '|  SUBROUTINE:  convertEcefToGeodetic',
     A              '|',
     B              '|    The computed complimentary Earth ellipticity',
     C              '|    squared value is invalid.',
     D              '|',
     E              '|    The computed complimentary Earth ellipticity',
     F              '|    squared value is expected to be strictly',
     F              '|    positive.',
     G              '|',
     H              '|    The computed complimentary Earth ellipticity'
C                ---------------------------------------------------------------
                   WRITE
     2              (
     3                STANDARD_OUTPUT,
     4                '( A, 0PES14.6 )'
     5              )
     6              '|    squared value is:-->',
     7              complimentaryEarthEllipticitySquared
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
     2                  (
     3                    STANDARD_OUTPUT,
     4                    '( A )'
     5                  )
     6                  '',
     7                  '',
     8                  ''
C                ---------------------------------------------------------------
C                  Assign invalid values to the output arguments.
C                ---------------------------------------------------------------
                   invalidValue       = 0.0D0
C                 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                   estimatedGeodeticNorthLatitudeRadians   =
     2                                               invalidValue
                   estimatedGeocentricEastLongitudeRadians =
     2                                               invalidValue
                   estimatedGeodeticAltitudeMeters         =
     2                                               invalidValue
C                }--------------------------------------------------------------
               ENDIF
C            }------------------------------------------------------------------
           ELSE
C            {------------------------------------------------------------------
C              The specified Earth equatorial radius value is infvalid.
C            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C              Generate a purpose message.
C            -------------------------------------------------------------------
               CALL
     2         generateConvertEcefToGeodeticPurposeMessage(  )
C            -------------------------------------------------------------------
C              Generate an usage message.
C            -------------------------------------------------------------------
               CALL
     2         generateConvertEcefToGeodeticUsageMessage(  )
C            -------------------------------------------------------------------
C              Generate an error message.
C            -------------------------------------------------------------------
               STANDARD_OUTPUT = 6
C            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
     9          '|  SUBROUTINE:  convertEcefToGeodetic',
     A          '|',
     B          '|    The specified Earth equatorial radius',
     C          '|    parameter value is invalid.',
     D          '|',
     E          '|    The Earth equatorial radius parameter',
     F          '|    value is expected to be strictly positive.',
     G          '|',
     H          '|    The specified Earth equatorial radius'
C            -------------------------------------------------------------------
               WRITE
     2          (
     3            STANDARD_OUTPUT,
     4            '( A, 0PES14.6 )'
     5          )
     6          '|    parameter value is:-->',
     7          earthEquatorialRadiusMeters
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
               estimatedGeodeticNorthLatitudeRadians   = invalidValue
               estimatedGeocentricEastLongitudeRadians = invalidValue
               estimatedGeodeticAltitudeMeters         = invalidValue
C            }------------------------------------------------------------------
           ENDIF
C         ----------------------------------------------------------------------
       ELSE
C        {----------------------------------------------------------------------
C          The specified Earth ellipsoidal flattening factor is invalid.
C         - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C          Generate a purpose message.
C         ----------------------------------------------------------------------
           CALL
     2     generateConvertEcefToGeodeticPurposeMessage(  );
C        -----------------------------------------------------------------------
C          Generate an usage message.
C         ----------------------------------------------------------------------
           CALL
     2     generateConvertEcefToGeodeticUsageMessage(  );
C        -----------------------------------------------------------------------
C          Generaete an error message.
C         ----------------------------------------------------------------------
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
     9      '|  SUBROUTINE:  convertEcefToGeodetic',
     A      '|',
     B      '|    The specified Earth ellipsoidal flattening',
     C      '|    factor is invalid.',
     D      '|',
     E      '|    The Earth ellipsoidal flattening factor',
     F      '|    be in the interval:  [ 0.0, 1.0 ).',
     G      '|',
     H      '|    The specified Earth ellipsoidal flattening'
C     --------------------------------------------------------------------------
           WRITE
     2      (
     3        STANDARD_OUTPUT,
     4        '( A, 0PES14.6 )'
     5      )
     6      '|    factor is:-->',
     7      earthEllipsoidalFlatteningFactor
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
     2      (
     3        STANDARD_OUTPUT,
     4        '( A )'
     5      )
     6      '',
     7      '',
     8      ''
C        -----------------------------------------------------------------------
C          Assign invalid values to the output arguments.
C        -----------------------------------------------------------------------
           invalidValue       = 0.0D0
C         - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           estimatedGeodeticNorthLatitudeRadians   = invalidValue
           estimatedGeocentricEastLongitudeRadians = invalidValue
           estimatedGeodeticAltitudeMeters         = invalidValue
C        }----------------------------------------------------------------------
       ENDIF
C-------------------------------------------------------------------------------
       RETURN
C}------------------------------------------------------------------------------
       END
C===============================================================================
