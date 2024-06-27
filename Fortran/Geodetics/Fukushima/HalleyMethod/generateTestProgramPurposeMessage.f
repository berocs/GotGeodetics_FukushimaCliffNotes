       SUBROUTINE
     2 generateTestProgramPurposeMessage(  )
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
     7  '| PURPOSE:',
     8  '|',
     9  '|    This program will test the conversion of Earth-Centered',
     A  '|    Earth-Fixed (ECEF) retangular coordinates to geodetics',
     B  '|    coordinates for a specified reference ellipsoid.',
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
     7  '|  METHOD:',
     8  '|',
     9  '|    [ 1 ] Uses the economic third-order Halley''s method to',
     A  '|          approximate a solution for the general non-linear',
     B  '|          geodetic equation numerically.',
     C  '|',
     D  '|    [ 2 ] Uses only one iteration of the iterative Halley''s',
     E  '|          method to achieve full double precision accuracy.',
     F  '|',
     G  '|    [ 3 ] Uses a technique to avoid division operations',
     H  '|          which significantly accelerates the backward',
     I  '|          transformation without degrading the precision.',
     J  '|'
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
     7  '|  STRATEGY:',
     8  '|',
     9  '|    [ 1 ]  Define true geodetic latitude and altitude',
     A  '|           values along the 45-degree East geocentric',
     B  '|           longitude meridian.',
     8  '|',
     C  '|    [ 2 ]  Generate true rectangular values based on the',
     D  '|           true geodetic latitude, true geodetic altitude',
     E  '|           and constant geocentric longitude values.',
     8  '|',
     F  '|    [ 3 ]  Compute estimated geodetic values based on the',
     G  '|           true rectangular values.',
     8  '|',
     H  '|    [ 4 ]  Report the differences between the defined true',
     I  '|           geodetic values and the estimated geodetic',
     J  '|           values.',
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
     7  '|  AUTHOR(s):',
     8  '|',
     9  '|    [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>',
     A  '|           National Astronomical Observatory of Japan',
     B  '|           (NAOJ)',
     C  '|           Address:  2-21-1, Ohsawa, Mitaka,',
     D  '|                     Tokyo 181-8588, Japan',
     E  '|           Phone:    +81-422-34-3613',
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
     7  '|  REFERENCE(s):',
     8  '|',
     9  '|    [ 1 ]  "Transformation from Cartesian to geodetic',
     A  '|            coordinates accelerated by Halley''s method",',
     B  '|           Toshio Fukushima,',
     C  '|           Journal Of Geodesy (2006),',
     D  '|           Volume 79,',
     E  '|           Pages 689-693',
     F  '|',
     G  '|    [ 2 ]  "Fast transform from geocentric to geodetic',
     H  '|           "coordinates",',
     I  '|           Toshio Fukushima,',
     J  '|           Journal Of Geodesy (1999),',
     K  '|           Volume 73,',
     L  '|           Pages 603–610',
     M  '|',
     N  '|    [ 3 ]  "Geometric Geodesy, Part A",',
     O  '|           "A set of lecture notes which are an',
     P  '|            introduction to ellipsoidal geometry related to',
     Q  '|            to geodesy.",',
     R  '|            R. E. Deakin and M. N. Hunter,',
     S  '|            School of Mathematical and Geospatial Sciences,',
     T  '|            RMIT University,',
     U  '|            Melbourne, Australia,',
     V  '|            January 2013',
     W  '|            www.mygeodesy.id.au/documents/Geometric%20',
     X  '|            Geodesy%20A(2013).pdf',
     Y  '|',
     Z  '|    [ 4 ]  "Various parameterizations of latitude',
     1  '|            equation -Cartesian to geodetic coordinates",',
     2  '|            transformation Marcin Ligas,',
     3  '|            Journal of Geodetic Science,',
     4  '|            Pages 87 - 94,',
     5  '|            2013',
     6  '|',
     7  '|    [ 5 ]  "In numerical analysis, Halley''s method is a',
     8  '|            root-finding algorithm used for functions of',
     9  '|            one real variable with a continuous second',
     A  '|            derivative.",',
     B  '|           "The rate of convergence of the iterative',
     C  '|            Halley''s method is cubic.",',
     D  '|           "There exist multidimensional versions of',
     E  '|            Halley''s method.",',
     F  '|           wikipedia.org/wiki/Halley''s_method',
     G  '|'
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
