def                                                                            \
convertEcefToGeodetic                                                          \
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

#-------------------------------------------------------------------------------
#|
#|  FUNCTION:
#|
#|    convertEcefToGeodetic 
#|
#|------------------------------------------------------------------------------
#|
#|  PURPOSE:
#|
#|    Convert Earth-Centered Earth-Fixed (ECEF) retangular coordinates to
#|    geodetic coordinates for a specified reference ellipsoid.
#|
#|------------------------------------------------------------------------------
#|
#|  METHOD:
#|
#|    [ 1 ] Uses the economic third-order Halley's method to solve the
#|          general non-linear geodetic equation numerically.
#|
#|    [ 2 ] Uses only  one iteration of the iterative Halley's method to
#|          achieve near double precision accuracy.
#|
#|    [ 3 ] Uses a technique to avoid division operations which significantly
#|          accelerates the backward transformation without degrading the
#|          precision.
#|
#|------------------------------------------------------------------------------
#|
#|  INPUT(s):
#|
#|    earthEquatorialRadiusMeters
#|      Length of Earth equatorial radius.
#|      Also length of Earth ellipsoid semi-major axis.
#|      UNIT(s):  [meters]
#|
#|    earthEllipsoidalFlatteningFactor
#|      Value of Earth ellipsoidal flattening factor.
#|      UNIT(s):  [nondimensional]
#|
#|    xGeocentricMeters
#|    yGeocentricMeters
#|    zGeocentricMeters
#|      Geocentric rectangular coordinates
#|      UNIT(s):  [meters]
#|
#|------------------------------------------------------------------------------
#|
#|  OUTPUT(s):
#|
#|    None
#|
#|------------------------------------------------------------------------------
#|
#|  RETURNED VALUE(s):
#|
#|    A one dimensional vector of length 4 containing the following
#|    return values:
#|
#|    [ 1 ]  An enumeration of the conversion status:
#|           Enumerated convesion status values are:
#|
#|             CONVERSION_SUCCESSFUL
#|               Conversion was successful.
#|
#|             UNDETERMINED_CONVERSION_STATUS
#|               Conversion status undetermined.
#|
#|             INVALID_EARTH_ELLIPSOIDAL_FLATTENING
#|               Encountered unacceptable value for Earth
#|               ellipsoidal flattening factor.
#|
#|             INVALID_EARTH_EQUATORIAL_RADIUS
#|               Encountered unacceptable value for Earth
#|               equatorial radius length.
#|
#|    [ 2 ]  The estimated North Geodetic latitude.
#|           Northern hemisphere is positive.
#|           UNITS: [radians]
#|
#|    [ 3 ]  The  estimated East Geocentric longitude.
#|           Eastward is positive.
#|           UNITS:  [radians]
#|
#|    [ 4 ]  The estimated Geodetic altitude above the specified
#|           reference ellipsoid.
#|           UNITS:  [meters]
#|
#|------------------------------------------------------------------------------
#|
#|  NOTE(s):
#|
#|    [ 1 ] This function is based on the FORTRAN subroutine gconv2h by
#|          Toshio Fukushima (see references).
#|
#|    [ 2 ] The specified equatorial radius length can be in any units,
#|          but meters is the conventional choice.
#|
#|    [ 3 ] The specified ellipsoidal flattening factor is (for the Earth)
#|
#|------------------------------------------------------------------------------
#|
#|  AUTHOR(s):
#|
#|    [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
#|           National Astronomical Observatory of Japan (NAOJ)
#|           Address:  2-21-1, Ohsawa, Mitaka, Tokyo   181-8588,  Japan
#|           Phone:    +81-422-34-3613
#|
#|------------------------------------------------------------------------------
#|
#|  REFERENCE(s):
#|
#|    [ 1 ]  "Transformation from Cartesian to geodetic
#|            coordinates accelerated by Halley's method",
#|           Toshio Fukushima,
#|           Journal Of Geodesy (2006),
#|           Volume 79,
#|           Pages 689-693
#|
#|    [ 2 ]  "Fast transform from geocentric to geodetic coordinates",
#|           Toshio Fukushima,
#|           Journal Of Geodesy (1999),
#|           Volume 73,
#|           Pages 603–610
#|
#|    [ 3 ]  "Geometric Geodesy, Part A",
#|           "A set of lecture notes which are an introduction to
#|            ellipsoidal geometry related to geodesy.",
#|           R. E. Deakin and M. N. Hunter,
#|           School of Mathematical and Geospatial Sciences,
#|           RMIT University,
#|           Melbourne, Australia,
#|           January 2013
#|           www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
#|
#|    [ 4 ]  'Various parameterizations of "latitude" equation -
#|            Cartesian to geodetic coordinates transformation',
#|            Marcin Ligas,
#|            Journal of Geodetic Science,
#|            Pages 87 - 94,
#|            2013
#|
#|    [ 5 ]  "In numerical analysis, Halley's method is a root-finding
#|            algorithm used for functions of one real variable with a
#|            continuous second derivative.",
#|           "The rate of convergence of the iterative Halley's method
#|            is cubic.",
#|           "There exist multidimensional versions of Halley's method.",
#|           wikipedia.org/wiki/Halley's_method`
#|
#|------------------------------------------------------------------------------
#|
#|  USAGE:
#|
#|    conversionReturnValue =                       \
#|    convertEcefToGeodetic                         \
#|           (                                      \
#|             earthEquatorialRadiusMeters,         \
#|             earthEllipsoidalFlatteningFactor,    \
#|             xGeocentricMeters,                   \
#|             yGeocentricMeters,                   \
#|             zGeocentricMeters                    \
#|           );
#| 
#{------------------------------------------------------------------------------
   import  math;
   import  os;
#-------------------------------------------------------------------------------
   from enum import IntEnum;
#-------------------------------------------------------------------------------
   from generateConvertEcefToGeodeticPurposeMessage                            \
                       import generateConvertEcefToGeodeticPurposeMessage;
   from generateConvertEcefToGeodeticUsageMessage                              \
                       import generateConvertEcefToGeodeticUsageMessage;
#-------------------------------------------------------------------------------
   class EcefToGeodeticConversionStatusEnum( IntEnum ):
         #{---------------------------------------------------------------------
            SUCCESS_STATUS                 = +1;
            UNDETERMINED_STATUS            =  0;
            INVALID_ELLIPSOIDAL_FLATTENING = -1;
            INVALID_EQUATORIAL_RADIUS      = -2;
         #}---------------------------------------------------------------------
#-------------------------------------------------------------------------------
   functionStatus = EcefToGeodeticConversionStatusEnum.UNDETERMINED_STATUS;
#-------------------------------------------------------------------------------
   if(
       ( earthEllipsoidalFlatteningFactor >= 0.0 )
       and
       ( earthEllipsoidalFlatteningFactor <  1.0 )
     ):
    #{--------------------------------------------------------------------------
    #  The Earth ellipsoidal flattening factor parameter value is valid.
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #  Continue validating the specified ellipsoid parameters.
    #---------------------------------------------------------------------------
       if( earthEquatorialRadiusMeters > 0.0 ):
        #{----------------------------------------------------------------------
        #  The Earth ellipsoid equatorial radius (major semiaxis length)
        #  parameter value is valid.
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #  Determine functions of the ellipsoid parameters.
        #-----------------------------------------------------------------------
           inverseEarthEquatorialRadius = 1.0 / earthEquatorialRadiusMeters;
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           eps           = 1.0e-16;
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           aEps          = earthEquatorialRadiusMeters * eps;
           aEpsSquared   = aEps * aEps;
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           earthEllipticitySquared =                                           \
                           ( 2.0 - earthEllipsoidalFlatteningFactor ) *        \
                                   earthEllipsoidalFlatteningFactor;
           earthEllipticityFourth  = earthEllipticitySquared *                 \
                                     earthEllipticitySquared;
           oneAndHalf_e4           = 1.5 * earthEllipticityFourth;
           complimentaryEarthEllipticitySquared = 1.0 - earthEllipticitySquared;
        #-----------------------------------------------------------------------
        #
        #  NOTE:
        #
        #    The fact that the ellipsoidal flattening factor parameter is
        #    valid guarantees that the squared complementary ellipsoidal
        #    parameter value ecSquared is strictly positive.
        #    We will check the the ecSquared value is strictly positive here
        #    anyway.
        #
        #-----------------------------------------------------------------------
           if( complimentaryEarthEllipticitySquared > 0.0 ):
            #{------------------------------------------------------------------
            #  The squared complementary ellipsoid parameter is valid.
            #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            #  Proceed with the geodetic computation.
            #-------------------------------------------------------------------
               complimentaryEarthEllipticity =                                 \
                            math.sqrt( complimentaryEarthEllipticitySquared );
               earthPolarRadiusMeters        =  complimentaryEarthEllipticity  \
                                                *                              \
                                                earthEquatorialRadiusMeters;
            #-------------------------------------------------------------------
            #  Distance from Earth polar axis squared.
            #-------------------------------------------------------------------
               earthPolarAxisDistanceSquared =                                 \
                          ( xGeocentricMeters * xGeocentricMeters ) +          \
                          ( yGeocentricMeters * yGeocentricMeters );
            #-------------------------------------------------------------------
            #  Determine Geocentric East Longitude [radians].
            #-------------------------------------------------------------------
               if( earthPolarAxisDistanceSquared > 0.0 ):
                #{--------------------------------------------------------------
                   estimatedGeocentricEastLongitude =                          \
                                              math.atan2( yGeocentricMeters,   \
                                                          xGeocentricMeters  );
                #}--------------------------------------------------------------
               else:
                #{--------------------------------------------------------------
                   estimatedGeocentricEastLongitude = 0.0;
                #}--------------------------------------------------------------
            #-------------------------------------------------------------------
            #  Unsigned Geocentric z-coordinate.
            #-------------------------------------------------------------------
               absZ = abs( zGeocentricMeters );
            #-------------------------------------------------------------------
               if( earthPolarAxisDistanceSquared > aEpsSquared ):
                #{--------------------------------------------------------------
                #  The specified Geocentric coordinates are
                #  sufficiently far from the polar axis for
                #  normal geodetic processing.
                #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                #  Determine distance from the polar axis.
                #---------------------------------------------------------------
                   earthPolarAxisDistanceMeters =                              \
                                 math.sqrt( earthPolarAxisDistanceSquared );
                #---------------------------------------------------------------
                #
                #  Perform normalization.
                #
                #---------------------------------------------------------------
                #  This is from Equation (2)  on Page 690 and
                #               Equation (17) on Page 691 of
                #  Reference [ 1 ].
                #  Here the factor of ec in Equation (2) is missing.
                #---------------------------------------------------------------
                   S0 = absZ * inverseEarthEquatorialRadius;
                #---------------------------------------------------------------
                #  This is Equation (2) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   Pn = earthPolarAxisDistanceMeters  *                        \
                        inverseEarthEquatorialRadius;
                   zc = complimentaryEarthEllipticity * S0;

                #---------------------------------------------------------------
                #
                #  Prepare the Newton correction factors.
                #
                #---------------------------------------------------------------

                #---------------------------------------------------------------
                #  This is Equation (17) on Page 691 of Reference [ 1 ].
                #---------------------------------------------------------------
                   C0        = complimentaryEarthEllipticity * Pn;
                #---------------------------------------------------------------
                   C0Squared = C0 * C0;
                   C0Cubed   = C0 * C0Squared;
                #---------------------------------------------------------------
                   S0Squared = S0 * S0;
                   S0Cubed   = S0 * S0Squared;
                #---------------------------------------------------------------
                #  This is Equation (14) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   A0Squared = C0Squared + S0Squared;
                   A0        = math.sqrt( A0Squared );
                   A0Cubed   = A0 * A0Squared;
                #---------------------------------------------------------------
                #  This is Equation (12) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   D0  = ( zc                      * A0Cubed )                 \
                         +                                                     \
                         ( earthEllipticitySquared * S0Cubed );
                #---------------------------------------------------------------
                #  This is Equation (13) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   F0  = (  Pn                      * A0Cubed )                \
                          +                                                    \
                         ( -earthEllipticitySquared * C0Cubed );

                #---------------------------------------------------------------
                #
                #  Prepare the Halley correction factors.
                #
                #---------------------------------------------------------------

                #---------------------------------------------------------------
                #  This is Equation (15) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   B0  = oneAndHalf_e4 *                                       \
                         S0Squared     *                                       \
                         C0Squared     *                                       \
                         Pn            *                                       \
                         ( A0 - complimentaryEarthEllipticity );
                #---------------------------------------------------------------
                #  This is Equation (10) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   S1  = ( D0 * F0 ) + ( -B0 * S0 );
                #---------------------------------------------------------------
                #  This is Equation (11) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   C1  = ( F0 * F0 ) + ( -B0 * C0 );
                #---------------------------------------------------------------
                #  This is Equation (21) on Page 691 of Reference [ 1 ].
                #---------------------------------------------------------------
                   Cc  = complimentaryEarthEllipticity * C1;

                #---------------------------------------------------------------
                #
                #  Evaluate geodetic latitude.
                #
                #---------------------------------------------------------------

                #---------------------------------------------------------------
                #  This is Equation (19) on Page 691 of Reference [ 1 ].
                #---------------------------------------------------------------
                   estimatedGeodeticNorthLatitude = math.atan2( S1, Cc );

                #---------------------------------------------------------------
                #
                #  Evaluate geodetic altitude.
                #
                #---------------------------------------------------------------
                   S1Squared = S1 * S1;
                   CcSquared = Cc * Cc;
                #---------------------------------------------------------------
                #  The quantity a1 is ec times A1.
                #  The quantity A1 is given by Equation (14) on
                #  Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   a1  =                                                       \
                     math.sqrt(                                                \
                                ( complimentaryEarthEllipticitySquared *       \
                                  S1Squared                              ) +   \
                                CcSquared                                      \
                              );
                #---------------------------------------------------------------
                #  This is Equation (20) on Page 691 of Reference [ 1 ].
                #---------------------------------------------------------------
                   estimatedGeodeticAltitude =                                 \
                           (                                                   \
                             (  earthPolarAxisDistanceMeters * Cc ) +          \
                             (  absZ                         * S1 ) +          \
                             ( -earthEquatorialRadiusMeters  * a1 )            \
                           ) / math.sqrt( CcSquared + S1Squared );
                #}--------------------------------------------------------------
               else:
                #{--------------------------------------------------------------
                #  The specified Geocentric coordinates are very near
                #  the polar axis.
                #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                #  Apply exceptional processing for the polar axis
                #  vincinity.
                #---------------------------------------------------------------
                   estimatedGeodeticNorthLatitude = math.pi / 2.0;
                   estimatedGeodeticAltitude      = absZ -                     \
                                                    earthPolarRadiusMeters;
                #}--------------------------------------------------------------
            #-------------------------------------------------------------------
               if( zGeocentricMeters < 0.0 ):
                #{--------------------------------------------------------------
                #  The specified Geocentric z coordinate is negative.
                #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                #  The specified Geocentric coorindates must be in the
                #  Southern Hemisphere.
                #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                #  Change the sign of the computed Geodetic Latitude.
                #---------------------------------------------------------------
                   estimatedGeodeticNorthLatitude =                            \
                                         -estimatedGeodeticNorthLatitude;
                #}--------------------------------------------------------------
            #-------------------------------------------------------------------
            #  Set the success status return value.
            #-------------------------------------------------------------------
               functionStatus = EcefToGeodeticConversionStatusEnum.            \
                                SUCCESS_STATUS;
            #-------------------------------------------------------------------
            #  Create a list to contain the return values.
            #-------------------------------------------------------------------
               returnValue = [                                                 \
                               functionStatus,                                 \
                               estimatedGeodeticNorthLatitude,                 \
                               estimatedGeocentricEastLongitude,               \
                               estimatedGeodeticAltitude                       \
                             ];
            #}------------------------------------------------------------------
           else:
            #{------------------------------------------------------------------
            #  The squared complementary Earth ellipsoid parameter is invalid.
            #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            #  Generate a purpose message.
            #-------------------------------------------------------------------
               generateConvertEcefToGeodeticPurposeMessage( );
            #-------------------------------------------------------------------
            #  Generate an usage message.
            #-------------------------------------------------------------------
               generateConvertEcefToGeodeticUsageMessage( );
            #-------------------------------------------------------------------
            #  Generate an error message.
            #-------------------------------------------------------------------
               print                                                           \
                (
                  "\n\n\n"
                );
               print                                                           \
                (
                  "============================================================",
                  "|",
                  "|  ERROR:",
                  "|",
                  "|    The squared complementary Earth ellipsoid parameter",
                  "|    value is invalid.",    
                  "|",
                  sep=os.linesep
                );
               print                                                           \
                (
                  "|    The squared complementary Earth ellipsoid parameter",
                  "|    value expected to be strictly positive.",
                  "|",
                  sep=os.linesep
                );
               print                                                           \
                (
                  "|    The squared complementary Earth ellipsoid parameter",
                  "|    value is:-->",
                  end=""
                );
               print                                                           \
                (
                  "%+20.6f" % ( complimentaryEarthEllipticitySquared )
                );
               print                                                           \
                (
                  "|",
                  "|    This is an error.",
                  "|",
                  "============================================================",
                  sep=os.linesep
                );
            #-------------------------------------------------------------------
            #  Set the error return value.
            #-------------------------------------------------------------------
               functionStatus = EcefToGeodeticConversionStatusEnum.            \
                                INVALID_ELLIPSOIDAL_FLATTENING;
            #-------------------------------------------------------------------
            #  Create a list to contain the return values.
            #-------------------------------------------------------------------
               returnValue = [                                                 \
                               functionStatus,                                 \
                               float( 'nan' ),                                 \
                               float( 'nan' ),                                 \
                               float( 'nan' )                                  \
                             ];
            #}------------------------------------------------------------------
        #}----------------------------------------------------------------------
       else:
        #{----------------------------------------------------------------------
        #  The ellipsoid equatorial radius (major semiaxis length)
        #  parameter value is invalid.
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #  Generate a purpose message.
        #-----------------------------------------------------------------------
           generateConvertEcefToGeodeticPurposeMessage( );
        #-----------------------------------------------------------------------
        #  Generate an usage message.
        #-----------------------------------------------------------------------
           generateConvertEcefToGeodeticUsageMessage( );
        #-----------------------------------------------------------------------
        #  Generate an error message.
        #-----------------------------------------------------------------------
           print                                                               \
            (
              "\n\n\n"
            );
           print                                                               \
            (
              "============================================================",
              "|",
              "|  ERROR:",
              "|",
              "|    The Earth equatorial radius parameter value",    
              "|    is invalid.",    
              "|",
              sep=os.linesep
            );
           print                                                               \
            (
              "|    The Earth equatorial radius parameter value is",
              "|    expected to be strictly positive.",
              "|",
              sep=os.linesep
            );
           print                                                               \
            (
              "|    The Earth equatorial radius parameter value",
              "|    is:-->",
              end=""
            );
           print                                                               \
            (
              "%+20.6f" % ( earthEquatorialRadiusMeters )
            );
           print                                                               \
            (
              "|",
              "|    This is an error.",
              "|",
              "============================================================",
              sep=os.linesep
            );
        #-----------------------------------------------------------------------
        #  Set the error return value.
        #-----------------------------------------------------------------------
           functionStatus = EcefToGeodeticConversionStatusEnum.                \
                            INVALID_EQUATORIAL_RADIUS;
        #-----------------------------------------------------------------------
        #  Create a list to contain the return values.
        #-----------------------------------------------------------------------
           returnValue = [                                                     \
                           functionStatus,                                     \
                           float( 'nan' ),                                     \
                           float( 'nan' ),                                     \
                           float( 'nan' )                                      \
                         ];
        #}----------------------------------------------------------------------
    #}--------------------------------------------------------------------------
   else:
    #{--------------------------------------------------------------------------
    #  The Earth ellipsoidal flattening factor parameter value is invalid.
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #  Generate a purpose message.
    #---------------------------------------------------------------------------
       generateConvertEcefToGeodeticPurposeMessage( );
    #0--------------------------------------------------------------------------
    #  Generate an usage message.
    #---------------------------------------------------------------------------
       generateConvertEcefToGeodeticUsageMessage( );
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
          "|    The Earth ellipsoidal flattening factor parameter",
          "|    value is invalid.",    
          "|",
          sep=os.linesep
        );
       print                                                                   \
        (
          "|    The Earth ellipsoidal flattening factor parameter",
          "|    value is expected to be in the interval:  [ 0.0, 1.0 ).",
          "|",
          "|    The Earth ellipsoidal flattening factor parameter",
          sep=os.linesep
        );
       print                                                                   \
        (
          "|    value is:-->",
          end=""
        );
       print                                                                   \
        (
          "%+20.6f" % ( earthEllipsoidalFlatteningFactor )
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
    #  Set the error return value.
    #---------------------------------------------------------------------------
       functionStatus = EcefToGeodeticConversionStatusEnum.                    \
                        INVALID_ELLIPSOIDAL_FLATTENING;
    #---------------------------------------------------------------------------
    #  Create a list to contain the return values.
    #---------------------------------------------------------------------------
       returnValue = [                                                         \
                       functionStatus,                                         \
                       float( 'nan' ),                                         \
                       float( 'nan' ),                                         \
                       float( 'nan' )                                          \
                     ];
    #}--------------------------------------------------------------------------
#-------------------------------------------------------------------------------
   return( returnValue );
#}------------------------------------------------------------------------------
