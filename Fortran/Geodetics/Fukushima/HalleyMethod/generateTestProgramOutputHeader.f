       SUBROUTINE
     2 generateTestProgramOutputHeader
     3   (
     4     specifiedFixedTrueEastGeocentricLongitudeDegrees
     5   )
C{------------------------------------------------------------------------------

C===============================================================================
C        1         2         3         4         5         6         7         8
C2345678901234567890123456789012345678901234567890123456789012345678901234567890
C===============================================================================

       IMPLICIT   NONE
C     --------------------------------------------------------------------------
       REAL*8     specifiedFixedTrueEastGeocentricLongitudeDegrees
       INTEGER*4  STANDARD_OUTPUT
C     --------------------------------------------------------------------------
       STANDARD_OUTPUT = 6
C     --------------------------------------------------------------------------
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '============================================================',
     7  '============================'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|',
     7  '| EARTH-CENTERED EARTH-FIXED (ECEF) RECTANGULAR COORDINATES'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '| TO GEODETIC CONVERSIONS USING THIRD ORDER HALLEY"S',
     7  ' ITERATIVE METHOD'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '| ONLY ONE HALLEY''s ITERATION IS USED TO ACHIEVE',
     6  '| FULL DOUBLE PRECISION ACCURACY.',
     7  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|-----------------------------------------------------------',
     7  '----------------------------'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     G  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, 0PF12.4, A  )'
     5  )
     6  '| True Geocentric East Longitude:-->',
     7  specifiedFixedTrueEastGeocentricLongitudeDegrees,
     8  ' [degrees]'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A )'
     5  )
     6  '|'
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|============================================================',
     7  '==========================='
       WRITE
     2  (
     3    STANDARD_OUTPUT,
     4    '( A, A )'
     5  )
     6  '|                   |                  ',
     7  '|    GEODETIC CONVERSION ERROR RESULTS',
     8  '|  True             |                  ',
     9  '|-----------------------------------------',
     A  '|  Geodetic         |  True            ',
     B  '|  Delta             |   Delta',
     C  '|  North            |  Geodetic        ',
     D  '|  Geodetic          |   Geodetic',
     E  '|  Latitude         |  Altitude        ',
     F  '|  Latitude          |   Altitude',
     G  '|-------------------+------------------',
     H  '+--------------------+--------------------',
     I  '|  [degrees]        |  [meters]        ',
     J  '|  [microArcSeconds] |   [nanoMeters]',
     K  '--------------------+------------------',
     k  '+--------------------+--------------------'
C     --------------------------------------------------------------------------
       RETURN
C     --------------------------------------------------------------------------
       END
C}------------------------------------------------------------------------------

C===============================================================================
