def                                                                            \
convertEcefToGeodeticOlsen                                                     \
       (                                                                       \
         earthEquatorialRadiusMeters,                                          \
         earthEllipsoidalFlatteningFactor,                                     \
         xGeocentricMeters,                                                    \
         yGeocentricMeters,                                                    \
         zGeocentricMeters                                                     \
       ):
#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------
#
#  REFERENCE(s):
#
#    [ 1 ] "Converting Earth-Centered, Earth-Fixed Coordinates to
#           Geodetic Coordinates",
#          Olson, D. K.,
#          IEEE Transactions on Aerospace and Electronic Systems,
#          32 (1996)
#          473-476.
#
#-------------------------------------------------------------------------------
#   Derived parameters.
#{------------------------------------------------------------------------------
    import math
#-------------------------------------------------------------------------------
    earthEllipticitySquared =         earthEllipsoidalFlatteningFactor   *     \
                              ( 2.0 - earthEllipsoidalFlatteningFactor );
    earthComplimentaryEllipticitySquared                                       \
                            = 1.0 - earthEllipticitySquared;
#-------------------------------------------------------------------------------
    a1                      =  earthEquatorialRadiusMeters *                   \
                               earthEllipticitySquared;
    a2                      = a1 * a1;
    a3                      = ( a1 * earthEllipticitySquared ) / 2.0;
    a4                      = 2.5 * a2;
    a5                      = a1  + a3;
#-------------------------------------------------------------------------------
    polarAxisDistance =                                                        \
        math.sqrt(                                                             \
                   ( xGeocentricMeters * xGeocentricMeters )                   \
                   +                                                           \
                   ( yGeocentricMeters * yGeocentricMeters )                   \
                 );
#-------------------------------------------------------------------------------
    zGeocentricMetersPositive = abs( zGeocentricMeters );
    polarAxisDistanceSquared  = polarAxisDistance *                            \
                                polarAxisDistance;
#-------------------------------------------------------------------------------
    r2 = ( zGeocentricMeters * zGeocentricMeters ) + polarAxisDistanceSquared;
    r  = math.sqrt( r2 );
#-------------------------------------------------------------------------------
    s2 = ( zGeocentricMeters * zGeocentricMeters ) / r2;
    c2 = polarAxisDistanceSquared / r2;
#-------------------------------------------------------------------------------
    u =        a2 / r;
    v = a3 - ( a4 / r );
#-------------------------------------------------------------------------------
    if( c2 > 0.3 ):
     #{-------------------------------------------------------------------------
     #
     #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #
     #--------------------------------------------------------------------------
        sineLatitude            = ( zGeocentricMetersPositive / r )            \
                                  *                                            \
                                  (                                            \
                                    1.0                                        \
                                    +                                          \
                                    (  c2 * ( a1 + u + ( s2 * v ) ) / r )      \
                                  );
        geodeticLatitudeRadians = math.asin( sineLatitude );
        sineLatitudeSquared     = sineLatitude * sineLatitude;
        cosineLatitude          = math.sqrt( 1.0 - sineLatitudeSquared );
     #}-------------------------------------------------------------------------
    else:
     #{-------------------------------------------------------------------------
     #
     #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #
     #--------------------------------------------------------------------------
        cosineLatitude          = ( polarAxisDistance / r )                    \
                                  *                                            \
                                  (                                            \
                                    1.0                                        \
                                    +                                          \
                                    ( -s2 * ( a5 - u - ( c2 * v ) ) / r )      \
                                  );
        geodeticLatitudeRadians = math.acos( cosineLatitude );
        sineLatitudeSquared     = 1.0 - ( cosineLatitude * cosineLatitude );
        sineLatitude            = math.sqrt( sineLatitudeSquared );
     #}-------------------------------------------------------------------------
#-------------------------------------------------------------------------------
    g                       = 1.0 -                                            \
                              (                                                \
                                earthEllipticitySquared                        \
                                *                                              \
                                sineLatitudeSquared                            \
                              );
    rg                      = earthEquatorialRadiusMeters / math.sqrt( g );
    rf                      = earthComplimentaryEllipticitySquared * rg;
#-------------------------------------------------------------------------------
    u                       = polarAxisDistance                                \
                              +                                                \
                              ( -rg * cosineLatitude );
    v                       = zGeocentricMetersPositive                        \
                              +                                                \
                              ( -rf *   sineLatitude );
#-------------------------------------------------------------------------------
#   This is a transformation (not rotation) of the 2 dimensional
#   vector [ u, v ].
#
#     |     |     |                                     |   |     |
#     |  f  |     |   cosineLatitude     sineLatitude   |   |  u  |
#     |     |  =  |                                     | * |     |
#     |  m  |     |  -  sineLatitude   cosineLatitude   |   |  v  |
#     |     |     |                                     |   |     |
#
#-------------------------------------------------------------------------------
    f                       = (  cosineLatitude * u ) + (   sineLatitude * v );
    m                       = ( -  sineLatitude * u ) + ( cosineLatitude * v );
#-------------------------------------------------------------------------------
    latitudeUpdateRadians   = m / ( ( rf / g ) + f );
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    geodeticLatitudeRadians = geodeticLatitudeRadians + latitudeUpdateRadians;
#-------------------------------------------------------------------------------
    if(  zGeocentricMeters < 0.0 ) :
     #{-------------------------------------------------------------------------
     #   Geocentric z coordinate is negative.
     #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #   Geocentric rectangular coordinates are in the Earth Southern
     #   Hemisphere
     #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #   Set the geodetic latitude value to the opposite (negative) value.
     #--------------------------------------------------------------------------
        geodeticLatitudeRadians = -geodeticLatitudeRadians
     #}-------------------------------------------------------------------------
#-------------------------------------------------------------------------------
    geocentricLongitudeRadians = math.atan2(                                   \
                                              yGeocentricMeters,               \
                                              xGeocentricMeters                \
                                           );
#-------------------------------------------------------------------------------
    geodeticAltitudeMeters     = f + ( ( m * latitudeUpdateRadians ) / 2.0 );
#-------------------------------------------------------------------------------
    return(                                                                    \
             geodeticLatitudeRadians,                                          \
             geocentricLongitudeRadians,                                       \
             geodeticAltitudeMeters                                            \
          );
#}------------------------------------------------------------------------------

