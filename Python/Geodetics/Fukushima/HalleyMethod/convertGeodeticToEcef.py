def                                                                            \
convertGeodeticToEcef                                                          \
       (                                                                       \
         earthEquatorialRadiusMeters,                                          \
         ellipsoidalEccentricitySquared,                                       \
         geodeticNorthLatitudeRadians,                                         \
         geocentricEastLongitudeRadians,                                       \
         geodeticAltitudeMeters                                                \
       ):
#===============================================================================
#|
#|  FUNCTION:
#|
#|    convertGeodeticToEcef
#|
#|------------------------------------------------------------------------------
#|
#|  PURPOSE:
#|
#|    Convert:
#|      Geodetic   Latitude,
#|      Geocentric Longitude
#|      Geodetic   Altitude
#|    to Earth-Centered Earth-Fixed (ECEF) rectangular coordinates.
#|
#|------------------------------------------------------------------------------
#|
#|  INPUT(s):
#|
#|    earthEquatorialRadiusMeters
#|      Length of Earth equatorial radius.
#|      Also length of ellipsoid semi-major axis.
#|      UNITS:  [meters]
#|
#|    ellipsoidalEccentricitySquared
#|      Earth ellipsoid eccentricity squared.
#|      UNITS:  [nondimensional]
#|
#|    geodeticNorthLatitudeRadians
#|      The North geodetic latitude.
#|      Northern hemisphere is positive.
#|      UNITS:  [radians]
#|
#|    geocentricEastLongitudeRadians
#|      The East Geocentric longitude.
#|      Eastward is positive.
#|      UNITS:  [radians]
#|
#|    geodeticAltitudeMeters
#|      The geodetic altitude above the specified reference ellipsoid.
#|      UNITS:  [meters]
#|
#|------------------------------------------------------------------------------
#|
#|  OUTPUT(s):
#|
#|    None.
#|
#|------------------------------------------------------------------------------
#|
#|  RETURNED VALUE(s):
#|
#|    A one dimensional vector of length 3 containing the following
#|    return values:
#|
#|    [ 1 ]  xEcefMeters
#|             The X ECEF position.
#|             UNITS:  [meters]
#|
#|    [ 2 ]  yEcefMeters
#|             The Y ECEF position.
#|             UNITS:  [meters]
#|
#|    [ 3 ]  zEcefMeters
#|             The Z ECEF position.
#|             UNITS:  [meters]
#|
#|------------------------------------------------------------------------------
#|
#|  REFERENCE(s):
#|
#|    [ 1 ]  "Geographic coordinate conversion",
#|           "Coordinate system conversion",
#|           "From geodetic to ECEF coordinates"
#|           https://en.wikipedia.org/wiki/Geographic_coordinate_conversion
#|
#|    [ 2 ]  "Geometric Geodesy, Part A",
#|           "A set of lecture notes which are an introduction to
#|            ellipsoidal geometry related to geodesy.",
#|           R. E. Deakin and M. N. Hunter,
#|           School of Mathematical and Geospatial Sciences,
#|           RMIT University,
#|           Melbourne, Australia,
#|           January 2013
#|           www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
#|
#|------------------------------------------------------------------------------
#|
#|  USAGE:
#|
#|  convertGeodeticToEcefReturnValue =
#|  convertGeodeticToEcef
#|         (
#|           earthEquatorialRadiusMeters,
#|           ellipsoidalEccentricitySquared,
#|           geodeticNorthLatitudeRadians,
#|           geocentricEastLongitudeRadians,
#|           geodeticAltitudeMeters
#|         ):
#|
#===============================================================================

#===============================================================================
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#===============================================================================

#{------------------------------------------------------------------------------
   import math;
   import os;
#-------------------------------------------------------------------------------
   from generateConvertGeodeticToEcefPurposeMessage                            \
                       import generateConvertGeodeticToEcefPurposeMessage;
   from generateConvertGeodeticToEcefUsageMessage                              \
                       import generateConvertGeodeticToEcefUsageMessage;
#-------------------------------------------------------------------------------
   sineOfGeodeticNorthLatitude     = math.sin( geodeticNorthLatitudeRadians   );
   cosineOfGeodeticNorthLatitude   = math.cos( geodeticNorthLatitudeRadians   );
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   sineOfGeocentricEastLongitude   = math.sin( geocentricEastLongitudeRadians );
   cosineOfGeocentricEastLongitude = math.cos( geocentricEastLongitudeRadians );
#-------------------------------------------------------------------------------
#
#  NOTE(s):
#
#    [ 1 ]  The value of the prime vertical radius of curvature, N, is
#           derived in Equation (48) of Section 1.1.6
#           "Geometry of the ellipse" pages 12 through 15 of
#           Reference [2].
#
#-------------------------------------------------------------------------------
   N                           =                                               \
   earthEquatorialRadiusMeters /                                               \
   math.sqrt(                                                                  \
              1.0E0 +                                                          \
              (                                                                \
                -ellipsoidalEccentricitySquared *                              \
                 sineOfGeodeticNorthLatitude    *                              \
                 sineOfGeodeticNorthLatitude                                   \
              )                                                                \
            );
#-------------------------------------------------------------------------------
   rho  = N + geodeticAltitudeMeters;
   rhoz = ( ( 1.0E0 - ellipsoidalEccentricitySquared ) * N ) +                 \
   geodeticAltitudeMeters;
#-------------------------------------------------------------------------------
#  Check the length quantities.
#-------------------------------------------------------------------------------
   if(                                                                         \
       ( rho  > 0.0E0 ) and                                                    \
       ( rhoz > 0.0E0 )                                                        \
     ):
    #{--------------------------------------------------------------------------
    #  The length quantities are all positive.
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #  Continue the computation of ECEF retangular coordinates.
    #
    #  NOTE(s):
    #
    #   [ 1 ]  The Earth Centered Earth Fixed (ECEF) coordinates
    #          { x, y, z } are computed via Equation (277) on page 94
    #          Section 2.1
    #          "Cartesian coords x,y,z given geodetic coords"
    #          of Reference [2].
    #
    #   [ 2 ]  The Earth Centered Earth Fixed (ECEF) coordinates
    #          { x, y, z } are derived on pages 92, 93 and 94 of
    #          Chapter 2
    #          "Transformations Between Cartesian Coordinates x,y,z
    #           and Geodetic Coordinates"
    #          of Reference [2].
    #
    #---------------------------------------------------------------------------
       r           = rho  * cosineOfGeodeticNorthLatitude;
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       xEcefMeters = r    * cosineOfGeocentricEastLongitude;
       yEcefMeters = r    *   sineOfGeocentricEastLongitude;
       zEcefMeters = rhoz *   sineOfGeodeticNorthLatitude;
    #}--------------------------------------------------------------------------
   else:
    #{--------------------------------------------------------------------------
    #  The length quantities are not all positive.
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #  Generate a purpose message.
    #---------------------------------------------------------------------------
       generateConvertGeodeticToEcefPurposeMessage( );
    #0--------------------------------------------------------------------------
    #  Generate an usage message.
    #---------------------------------------------------------------------------
       generateConvertGeodeticToEcefUsageMessage( );
    #---------------------------------------------------------------------------
    #  Generate an error message.
    #---------------------------------------------------------------------------
       print                                                                   \
        (
          "\n\n\n"
        );
       print                                                                   \
        (
          "============================================================",
          "|",
          "|  ERROR:",
          "|",
          "|    The computeed length quantities rho and rhoz are",
          "|    not both positive.",
          "|",
          sep=os.linesep
        );
       print                                                                   \
        (
          "|    Computed value for rho  is:-->",
          end=""
        );
       print                                                                   \
        (
          "%+20.6f" % rho
        );
       print                                                                   \
        (
          "|    Computed value for rhoz is:-->",
          end=""
        );
       print                                                                   \
        (
          "%+20.6f" % rhoz
        );
       print                                                                   \
        (
          "|",
          "|    This is an error.",
          "|",
          "============================================================",
          sep=os.linesep
        );
    #---------------------------------------------------------------------------
    #  Assign invalid values to the output arguments.
    #---------------------------------------------------------------------------
       xEcefMeters = float( 'nan' );
       yEcefMeters = float( 'nan' );
       zEcefMeters = float( 'nan' );
    #}-------------------------------------------------------------------------
#-------------------------------------------------------------------------------
   returnValue = [                                                             \
                    xEcefMeters,                                               \
                    yEcefMeters,                                               \
                    zEcefMeters                                                \
                 ];
#-------------------------------------------------------------------------------
   return( returnValue );
#}------------------------------------------------------------------------------
