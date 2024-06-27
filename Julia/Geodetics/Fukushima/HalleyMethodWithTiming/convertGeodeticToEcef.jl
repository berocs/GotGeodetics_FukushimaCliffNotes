function
convertGeodeticToEcef(
                       earthEquatorialRadiusMeters,
                       earthEllipsoidalEccentricitySquared,
                       geodeticNorthLatitudeRadians,
                       geocentricEastLongitudeRadians,
                       geodeticAltitudeMeters
                     )
#-------------------------------------------------------------------------------
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
#|    to Earth Center Earth Fixed (ECEF) rectangular coordinates.
#|
#|------------------------------------------------------------------------------
#|
#|  INPUTS:
#|
#|    earthEquatorialRadiusMeters
#|      Length of Earth equatorial radius
#|      Also length of Earth ellipsoid semi-major axis.
#|      UNIT(s):  [meters]
#|
#|    earthEllipsoidalEccentricitySquared
#|      Earth ellipsoid eccentricity squared.
#|      UNIT(s):  [nondimensional]
#|
#|    geodeticNorthLatitudeRadians
#|      The geodetic North latitude.
#|      Northern hemisphere is positive.
#|      UNIT(s):  [radians]
#|
#|    geocentricEastLongitudeRadians
#|      The Geocentric East longitude.
#|      Eastward is positive.
#|      UNIT(s):  [radians]
#|
#|    geodeticAltitudeMeters
#|      The geodetic altitude above the specified reference ellipsoid.
#|      UNIT(s):  [meters]:
#|
#|------------------------------------------------------------------------------
#|
#|  OUTPUT:
#|
#|    None
#|
#|------------------------------------------------------------------------------
#|
#|  RETURNED VALUE:
#|
#|    A vector of length 3 containing:
#|
#|     returnValue( 1 )
#|       The X ECEF position.
#|       UNIT(s):  [meters]
#|
#|     returnValue( 2 )
#|       The Y ECEF position.
#|       UNIT(s):  [meters]
#|
#|     returnValue( 3 )
#|       The Z ECEF position.
#|       UNIT(s):  [meters]
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
#|    convertGeodeticToEcefReturnValue =
#|    convertGeodeticToEcef
#|           (
#|               earthEquatorialRadiusMeters,
#|               earthEllipsoidalEccentricitySquared,
#|               geodeticNorthLatitudeRadians,
#|               geocentricEastLongitudeRadians,
#|               geodeticAltitudeMeters
#|           );
#|
#|    xEcefMeters = convertGeodeticToEcefReturnValue[ 1 ];
#|    yEcefMeters = convertGeodeticToEcefReturnValue[ 2 ];
#|    zEcefMeters = convertGeodeticToEcefReturnValue[ 3 ];
#|
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#{------------------------------------------------------------------------------
     sineOfGeodeticNorthLatitude    = sin( geodeticNorthLatitudeRadians   );
   cosineOfGeodeticNorthLatitude    = cos( geodeticNorthLatitudeRadians   );
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     sineOfGeocentricEastLongitude = sin( geocentricEastLongitudeRadians );
   cosineOfGeocentricEastLongitude = cos( geocentricEastLongitudeRadians );
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
   N    = earthEquatorialRadiusMeters /
          sqrt(
                1.0E0 +
                (
                  -earthEllipsoidalEccentricitySquared *
                   sineOfGeodeticNorthLatitude         *
                   sineOfGeodeticNorthLatitude
                )
              );
#-------------------------------------------------------------------------------
   rho  = N + geodeticAltitudeMeters;
   rhoz = ( ( 1.0E0 - earthEllipsoidalEccentricitySquared ) * N ) +
          geodeticAltitudeMeters;
#-------------------------------------------------------------------------------
#  Check the length quantities.
#-------------------------------------------------------------------------------
   if(
       ( rho  > 0.0E0 ) &&
       ( rhoz > 0.0E0 )
     )
    #{--------------------------------------------------------------------------
    #  The length quantities are all positive.
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #  Continue the computation of ECEF retangular coordinates.
    #
    #  NOTE(s):
    #
    #    [ 1 ]  The Earth Centered Earth Fixed (ECEF) coordinates
    #           { x, y, z } are computed via Equation (277) on page 94
    #           Section 2.1
    #           "Cartesian coords x,y,z given geodetic coords"
    #           of Reference [2].
    #
    #    [ 2 ]  The Earth Centered Earth Fixed (ECEF) coordinates
    #           { x, y, z } are derived on pages 92, 93 and 94 of
    #           Chapter 2
    #           "Transformations Between Cartesian Coordinates x,y,z
    #            and Geodetic Coordinates"
    #           of Reference [2].
    #
    #---------------------------------------------------------------------------
       r           = rho  * cosineOfGeodeticNorthLatitude;
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       xEcefMeters = r    * cosineOfGeocentricEastLongitude;
       yEcefMeters = r    *   sineOfGeocentricEastLongitude;
       zEcefMeters = rhoz *   sineOfGeodeticNorthLatitude;
    #}--------------------------------------------------------------------------
   else
    #{--------------------------------------------------------------------------
    #  The length quantities are not all positive.
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #  Generate a purpose message.
    #---------------------------------------------------------------------------
       generateConvertGeodeticToEcefPurposeMessage(  );
    #---------------------------------------------------------------------------
    #  Generate a usage message.
    #---------------------------------------------------------------------------
       generateConvertGeodeticToEcefUsageMessage(  );
    #---------------------------------------------------------------------------
    #  Generate an error message.
    #---------------------------------------------------------------------------
       formatString =
             string(   
                     "\n\n\n",
                     "%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
                     "%s%14.6e\n",
                     "%s%14.6e\n",
                     "%s\n%s\n%s\n%s\n",
                     "\n\n\n"
                   );
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       printFormatted(
         stdout,
         formatString,
         "============================================================",
         "|",
         "|  ERROR:",
         "|",
         "|    The computeed length quantities rho and rhoz are",
         "|    not both positive.",
         "|",
         "|    Computed value for rho  is:-->",
         rho,
         "|    Computed value for rhoz is:-->",
         rhoz,
         "|",
         "|    This is an error.",
         "|",
         "============================================================"
       );
    #---------------------------------------------------------------------------
    #  Assign invalid values to the output arguments.
    #---------------------------------------------------------------------------
       xEcefMeters = NaN64;
       yEcefMeters = NaN64;
       zEcefMeters = NaN64;
    #}-------------------------------------------------------------------------
   end;
#-------------------------------------------------------------------------------
   returnValue = [
                   xEcefMeters,
                   yEcefMeters,
                   zEcefMeters,
                 ];
#-------------------------------------------------------------------------------
   return( returnValue );
#-------------------------------------------------------------------------------
   end;
#}------------------------------------------------------------------------------
