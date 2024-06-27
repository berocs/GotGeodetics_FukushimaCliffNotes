       SUBROUTINE
     2 generateConvertGeodeticToEcefPurposeMessage(  )
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
     9  '|    convertGeodeticToEcef',
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
     9  '|    Convert:',
     A  '|      Geodetic   Latitude,',
     B  '|      Geocentric Longitude',
     C  '|      Geodetic   Altitude',
     D  '|    to Earth Centered Earth Fixed (ECEF) rectangular',
     E  '|    coordinates.',
     F  '|'
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
     8  '|',
     9  '|     earthEquatorialRadiusMeters',
     A  '|       Length of Earth equatorial radius',
     B  '|       Also length of Earth ellipsoid semi-major axis.',
     D  '|       UNITS:  [meters]',
     E  '|',
     F  '|     earthEllipsoidalEccentricitySquared',
     G  '|       Earth ellipsoid eccentricity squared.',
     H  '|       UNITS:  [nondimensional]',
     I  '|',
     J  '|     geodeticNorthLatitudeRadians',
     K  '|       The North geodetic latitude.',
     L  '|       Northern hemisphere is positive.',
     M  '|       UNITS:  [radians]',
     N  '|',
     O  '|     geocentricEastLongitudeRadians',
     P  '|       The East Geocentric longitude.',
     Q  '|       Eastward is positive.',
     R  '|       UNITS:  [radians]',
     S  '|',
     T  '|     geodeticAltitudeMeters',
     U  '|       The geodetic altitude above the specified reference',
     V  '|       ellipsoid.',
     W  '|       UNITS:  [meters]',
     X  '|'
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
     7  '|  OUTPUT:',
     8  '|',
     9  '|     rXEcefMeters',
     A  '|       X ECEF position.',
     B  '|       UNITS:  [meters]',
     C  '|',
     D  '|     rYEcefMeters',
     E  '|       Y ECEF position.',
     F  '|       UNITS:  [meters]',
     G  '|',
     H  '|     rZEcefMeters',
     I  '|       Z ECEF position.',
     J  '|       UNITS:  [meters]',
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
     7  '|  RETURNED VALUE:',
     8  '|',
     9  '|    None.',
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
     7  '|  REFERENCE(s):',
     8  '|',
     9  '|     [ 1 ]  "Geographic coordinate conversion",',
     A  '|            "Coordinate system conversion",',
     B  '|            "From geodetic to ECEF coordinates"',
     C  '|            https://en.wikipedia.org/wiki/',
     D  '|            Geographic_coordinate_conversion',
     E  '|',
     F  '|     [ 2 ]  "Geometric Geodesy, Part A",',
     G  '|            "A set of lecture notes which are an',
     H  '|             introduction to ellipsoidal geometry',
     I  '|             related to geodesy.",',
     J  '|            R. E. Deakin and M. N. Hunter,',
     K  '|            School of Mathematical and Geospatial',
     L  '|            Sciences,',
     M  '|            RMIT University,',
     N  '|            Melbourne, Australia,',
     O  '|            January 2013',
     P  '|            www.mygeodesy.id.au/documents/Geometric%20',
     Q  '|            Geodesy%20A(2013).pdf',
     R  '|'
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
