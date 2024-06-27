       SUBROUTINE
     2 generateConvertEcefToGeodeticPurposeMessage(  )
C{------------------------------------------------------------------------------

C===============================================================================
C        1         2         3         4         5         6         7
C2345678901234567890123456789012345678901234567890123456789012345678901234567890
C===============================================================================

C     --------------------------------------------------------------------------
       IMPLICIT   NONE
       INTEGER*4  STANDARD_OUTPUT
C     --------------------------------------------------------------------------
       STANDARD_OUTPUT = 6
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
     6  '============================================================',
     7  '========'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|  SUBROUTINE:',
     8  '|',
     9  '|    convertEcefToGeodetic',
     A  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|-----------------------------------------------------------',
     7  '--------'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|  PURPOSE:',
     8  '|',
     9  '|    A Fortran subroutine to convert geocentric rectangular',
     A  '|    coordinates to geodetic coordinates by applying',
     B  '|    Halley''s iterative method using only one iteration',
     C  '|    to achieve near double precision precision accuracy.',
     D  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|-----------------------------------------------------------',
     7  '--------'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|  METHOD:',
     8  '|',
     9  '|    [ 1 ] Uses the economic third-order Halley''s method to',
     A  '|          approximate a solution for the general non-linear',
     B  '|          geodetic equation numerically.',
     C  '|',
     D  '|    [ 2 ] Uses only  one iteration of the iterative',
     E  '|          Halley''s method to achieve full double precision',
     F  '|          accuracy.',
     G  '|',
     H  '|    [ 3 ] Uses a technique to avoid division operations',
     I  '|          which significantly accelerates the backward',
     J  '|          transformation without degrading the precision.',
     K  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|-----------------------------------------------------------',
     7  '--------'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|  INPUTS:',
     8  '}',
     9  '|    earthEquatorialRadiusMeters',
     A  '|      Length of Earth equatorial radius',
     B  '|      Also length of Earth ellipsoid semi-major axis.',
     C  '|      Units:  [meters]',
     D  '|',
     E  '|    earthEllipsoidalFlatteningFactor',
     F  '|      Value of Earth ellipsoidal flattening factor, f.',
     G  '|      Units:  [nondimensional]',
     H  '|',
     I  '|    xRectangularMeters',
     J  '|      Rectangular X coordinate value.',
     K  '|      UNITS:  [meters]',
     L  '}',
     M  '|    yRectangularMeters',
     N  '|      Rectangular Y coordinate value.',
     O  '|      UNITS:  [meters]',
     P  '}',
     Q  '|    zRectangularMeters',
     R  '|      Rectangular Z coordinate value.',
     S  '|      UNITS:  [meters]',
     T  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|-----------------------------------------------------------',
     7  '--------'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|  OUTPUTS:',
     8  '|',
     9  '|    estimatedGeodeticNorthLatitudeRadians',
     A  '|      Estimated North Geodetic   latitude.',
     B  '|      UNITS:  [radians]',
     C  '|',
     D  '|    estimatedGeocentricEastLongitudeRadians',
     E  '|      Estimated East Geocentric longitude.',
     F  '|      UNITS:  [radians]',
     G  '|',
     H  '|    estimatedGeodeticAltitudeMeters',
     I  '|      Estimated Geodetic   altitude.',
     J  '|      UNITS:  [meters]',
     K  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|-----------------------------------------------------------',
     7  '--------'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|  NOTE(s):',
     8  '|',
     9  '|    [ 1 ] This function is based on the FORTRAN',
     A  '|          subroutine gconv2h by Toshio Fukushima',
     B  '|          (see reference).',
     C  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|-----------------------------------------------------------',
     7  '--------'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|  AUTHOR(s):',
     8  '|',
     9  '|    [ 1 ]  Toshio Fukushima',
     A  '|           <Toshio.Fukushima@nao.ac.jp>',
     B  '|           National Astronomical Observatory of',
     C  '|           Japan (NAOJ)',
     D  '|           Address:  2-21-1, Ohsawa, Mitaka, Tokyo',
     E  '|           181-8588,  Japan',
     F  '|           Phone:    +81-422-34-3613',
     G  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|-----------------------------------------------------------',
     7  '--------'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '|  REFERENCE(s):',
     8  '|',
     9  '|    [ 1 ]  "Transformation from Cartestian to Geodetic',
     A  '|            Coordinates Accelerated by Halley''s Method",',
     B  '|           Toshio Fukushima',
     C  '|           2006, Journal of Geodesy,',
     D  '|           Volume 79',
     E  '|           Pages 689-693',
     F  '|',
     G  '|    [ 2 ]  "Fast transform from geocentric to geodetic',
     H  '|            coordinates",',
     I  '|           Toshio Fukushima,',
     J  '|           Journal Of Geodesy (1999),',
     K  '|           Volume 73,',
     L  '|           Pages 603–610',
     M  '|',
     N  '|    [ 3 ]  "Geometric Geodesy, Part A",',
     O  '|           "A set of lecture notes which are an introduction',
     P  '|            to ellipsoidal geometry related to geodesy.",',
     Q  '|            R. E. Deakin and M. N. Hunter,',
     R  '|            School of Mathematical and Geospatial Sciences,',
     S  '|            RMIT University,',
     T  '|            Melbourne, Australia,',
     U  '|            January 2013',
     V  '|            www.mygeodesy.id.au/documents/Geometric',
     W  '|            %20Geodesy%20A(2013).pdf',
     X  '|',
     Y  '|    [ 4 ]  "Various parameterizations of latitude equation -',
     Z  '|            Cartesian to geodetic coordinates',
     A  '|            transformation",',
     B  '|            Marcin Ligas,',
     C  '|            Journal of Geodetic Science,',
     D  '|            Pages 87 - 94,',
     E  '|            2013',
     F  '|',
     G  '|    [ 5 ]  "In numerical analysis, Halley''s method is a',
     H  '|            root-finding algorithm used for functions of',
     I  '|            one real variable with a continuous second',
     J  '|            derivative.",',
     K  '|           "The rate of convergence of the iterative',
     L  '|            Halley''s method is cubic.",',
     M  '|           "There exist multidimensional versions of',
     N  '|            Halley''s method.",',
     O  '|           wikipedia.org/wiki/Halley''s_method`',
     P  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|===========================================================',
     7  '========'
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
       RETURN
C     --------------------------------------------------------------------------
       END
C}------------------------------------------------------------------------------

C===============================================================================
