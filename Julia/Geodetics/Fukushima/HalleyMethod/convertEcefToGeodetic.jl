function
convertEcefToGeodetic(
                       earthEquatorialRadiusMeters,
                       earthEllipsoidalFlatteningFactor,
                       xRectangularMeters,
                       yRectangularMeters,
                       zRectangularMeters
                     )
#-------------------------------------------------------------------------------
#
#   FUNCTION:
#
#     convertEcefToGeodetic 
#
#-------------------------------------------------------------------------------
#
#   PURPOSE:
#
#     Convert Earth-Centered Earth-Fixed (ECEF) retangular coordinates
#     to geodetic coordinates for a specified reference ellipsoid.
#
#-------------------------------------------------------------------------------
#
#   METHOD:
#
#     [ 1 ] Uses the economic third-order Halley's method to solve the
#           general non-linear geodetic equation numerically.
#
#     [ 2 ] Uses only  one iteration of the iterative Halley's method
#           to achieve near double precision accuracy.
#
#     [ 3 ] Uses a technique to avoid division operations which significantly
#           accelerates the backward transformation without degrading the
#           precision.
#
#-------------------------------------------------------------------------------
#
#   INPUT(s):
#
#     earthEquatorialRadiusMeters
#       Length of Earth equatorial radius
#       Also length of Earth ellipsoid semi-major axis.
#       UNIT(s):  [meters]
#
#     earthEllipsoidalFlatteningFactor
#       Value of Earth ellipsoidal flattening factor.
#       UNIT(s):  [nondimensional]
#
#     xRectangularMeters
#     yRectangularMeters
#     zRectangularMeters
#       X, Y and Z rectangular coordinates.
#       UNIT(s):  [meters]
#
#-------------------------------------------------------------------------------
#
#   OUTPUT(s):
#
#     None
#
#-------------------------------------------------------------------------------
#
#   RETURNED VALUE(s):
#
#     A vector of length 4 containing:
#
#     [ 1 ] functionStatus
#             An enumeration of the conversion status:
#               @enum(
#                      
#                      SUCCESS_STATUS                 = +1,
#                      UNDETERMINED_STATUS            =  0,
#                      INVALID_ELLIPSOIDAL_FLATTENING = -1,
#                      INVALID_EQUATORIAL_RADIUS      = -2
#                    );
#             SUCCESS_STATUS
#               Function was successful.
#             UNDETERMINED_STATUS
#               Function status undetermined.
#             INVALID_ELLIPSOIDAL_FLATTENING
#               Unacceptable value for ellipsoidal flattening detected.
#             INVALID_EQUATORIAL_REDIUS
#               Unacceptable value for equatorial radius length detected.
#
#     [ 2 ] estimatedGeodeticNorthLatitudeRadians
#             Estimated Geodetic North latitude.
#             Northern hemisphere is positive.
#             UNIT(s):  [radians]
#
#     [ 3 ] estimatedGeocentricEastLongitudeRadians
#             The estimated Geocentric East longitude.
#             Eastward is positive.
#             UNIT(s):  [radians]
#
#     [ 4 ] estimatedGeodeticAltitudeMeters
#             The estimated Geodetic altitude above the specified
#             reference ellipsoid.
#             UNIT(s):  [meters]
#
#-------------------------------------------------------------------------------
#
#   NOTE(s):
#
#     [ 1 ] This function is based on the FORTRAN subroutine gconv2h by
#           Toshio Fukushima (see references).
#
#-------------------------------------------------------------------------------
#
#   AUTHOR(s):
#
#     [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
#            National Astronomical Observatory of Japan (NAOJ)
#            Address:  2-21-1, Ohsawa, Mitaka, Tokyo   181-8588,  Japan
#            Phone:    +81-422-34-3613
#
#-------------------------------------------------------------------------------
#
#   REFERENCE(s):
#
#     [ 1 ]  "Transformation from Cartesian to geodetic
#             coordinates accelerated by Halley's method",
#            Toshio Fukushima,
#            Journal Of Geodesy (2006),
#            Volume 79,
#            Pages 689-693
#
#     [ 2 ]  "Fast transform from geocentric to geodetic coordinates",
#            Toshio Fukushima,
#            Journal Of Geodesy (1999),
#            Volume 73,
#            Pages 603–610
#
#     [ 3 ]  "Geometric Geodesy, Part A",
#            "A set of lecture notes which are an introduction to
#             ellipsoidal geometry related to geodesy.",
#            R. E. Deakin and M. N. Hunter,
#            School of Mathematical and Geospatial Sciences,
#            RMIT University,
#            Melbourne, Australia,
#            January 2013
#            www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
#
#    [ 4 ]  'Various parameterizations of "latitude" equation -
#            Cartesian to geodetic coordinates transformation',
#            Marcin Ligas,
#            Journal of Geodetic Science,
#            Pages 87 - 94,
#            2013
#
#    [ 5 ]  "In numerical analysis, Halley's method is a root-finding
#            algorithm used for functions of one real variable with a
#            continuous second derivative.",
#           "The rate of convergence of the iterative Halley's method
#            is cubic.",
#           "There exist multidimensional versions of Halley's method.",
#           wikipedia.org/wiki/Halley's_method`
#
#-------------------------------------------------------------------------------
#
#  USAGE:
#
#    convertEcefToGeodeticReturnValue =
#    convertEcefToGeodetic(
#                           earthEquatorialRadiusMeters,
#                           earthEllipsoidalFlatteningFactor,
#                           xRectangularMeters,
#                           yRectangularMeters,
#                           zRectangularMeters
#                         );
#    conversionStatus               = convertEcefToGeodeticReturnValue[ 1 ];
#    geodeticNorthLatitudeRadians   = convertEcefToGeodeticReturnValue[ 2 ];
#    geocentricEastLongitudeRadians = convertEcefToGeodeticReturnValue[ 3 ];
#    geodeticAltitudeMeters         = convertEcefToGeodeticReturnValue[ 4 ];
#
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#{------------------------------------------------------------------------------
   functionStatus = UNDETERMINED_STATUS;
#-------------------------------------------------------------------------------
   if(
       ( earthEllipsoidalFlatteningFactor >= 0.0 )
       &&
       ( earthEllipsoidalFlatteningFactor <  1.0 )
     )
    #{--------------------------------------------------------------------------
    #  The ellipsoidal flattening factor parameter value is valid.
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #  Continue validating the specified ellipsoid parameters.
    #---------------------------------------------------------------------------
       if( earthEquatorialRadiusMeters > 0.0 )
        #{----------------------------------------------------------------------
        #  The ellipsoid equatorial radius (major semiaxis length)
        #  parameter value is valid.
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #  Determine functions of the ellipsoid parameters.
        #-----------------------------------------------------------------------
           inverseEarthEquatorialRadius = 1.0 / earthEquatorialRadiusMeters;
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           eps   = 1.0e-16;
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           aEps        = earthEquatorialRadiusMeters * eps;
           aEpsSquared = aEps * aEps;
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           earthEllipticitySquared = ( 2.0 -
                                       earthEllipsoidalFlatteningFactor ) *
                                       earthEllipsoidalFlatteningFactor;
           earthEllipticityForth   = earthEllipticitySquared *
                                     earthEllipticitySquared;
           oneAndHalf_e4           = 1.5 * earthEllipticityForth;
           complimentaryEarthEllipticitySquared = 1.0 -
                                                  earthEllipticitySquared;
        #-----------------------------------------------------------------------
        #
        #  NOTE:
        #
        #    The fact that the ellipsoidal flattening factor parameter is
        #    valid guarantees that the squared complementary ellipsoidal
        #    parameter value ec2 is strictly positive.
        #    We will check the the ec2 value is strictly positive here
        #    anyway.
        #
        #-----------------------------------------------------------------------
           if( complimentaryEarthEllipticitySquared > 0.0 )
            #{------------------------------------------------------------------
            #  The squared complimentary ellipsoid parameter is valid.
            #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            #  Proceed with the geodetic computation.
            #-------------------------------------------------------------------
               complimentaryEarthEllipticity =
                                   sqrt( complimentaryEarthEllipticitySquared );
               earthPolarRadiusMeters  = complimentaryEarthEllipticity *
                                         earthEquatorialRadiusMeters;
            #-------------------------------------------------------------------
            #  Distance from polar axis squared.
            #-------------------------------------------------------------------
               earthPolarAxisDistanceSquared = ( xRectangularMeters *
                                                 xRectangularMeters   ) +
                                               ( yRectangularMeters *
                                                 yRectangularMeters   );
            #-------------------------------------------------------------------
            #  Determine Geocentric Longitude [radians].
            #-------------------------------------------------------------------
               estimatedGeocentricEastLongitudeRadians =
                    ( earthPolarAxisDistanceSquared > 0.0 ) ?
                                   atan( yRectangularMeters,
                                         xRectangularMeters  ) : 0.0;
            #-------------------------------------------------------------------
            #  Absolute Rectangular z-coordinate.
            #-------------------------------------------------------------------
               absZ = abs( zRectangularMeters );
            #-------------------------------------------------------------------
               if( earthPolarAxisDistanceSquared > aEpsSquared )
                #{--------------------------------------------------------------
                #  The specified Rectangular coordinates are
                #  sufficiently far from the polar axis for
                #  normal geodetic processing.
                #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                #  Determine distance from the polar axis.
                #---------------------------------------------------------------
                   earthPolarAxisDistanceMeters =
                                       sqrt( earthPolarAxisDistanceSquared );
                #---------------------------------------------------------------
                #
                #  Perform normalization.
                #
                #---------------------------------------------------------------
                #  This is from Equation (2)  on Page 690 and
                #               Equation (17) on Page 691 of Reference [ 1 ]
                #  Here the factor of ec in Equation (2) is missing.
                #---------------------------------------------------------------
                   S0 = absZ * inverseEarthEquatorialRadius;
                #---------------------------------------------------------------
                #  This is Equation (2) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   Pn = earthPolarAxisDistanceMeters  *
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
                   C0  = complimentaryEarthEllipticity * Pn;
                #---------------------------------------------------------------
                   C0Squared = C0 * C0;
                   C0Cubed   = C0 * C0Squared;
                #---------------------------------------------------------------
                   S0Squared = S0  * S0;
                   S0Cubed   = S0 * S0Squared;
                #---------------------------------------------------------------
                #  This is Equation (14) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   A0Squared = C0Squared + S0Squared;
                   A0        = sqrt( A0Squared );
                   A0Cubed   = A0 * A0Squared;
                #---------------------------------------------------------------
                #  This is Equation (12) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   D0  = ( zc                      * A0Cubed ) +
                         ( earthEllipticitySquared * S0Cubed );
                #---------------------------------------------------------------
                #  This is Equation (13) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   F0  = (  Pn                      * A0Cubed ) +
                         ( -earthEllipticitySquared * C0Cubed );

                #---------------------------------------------------------------
                #
                #  Prepare the Halley correction factors.
                #
                #---------------------------------------------------------------

                #---------------------------------------------------------------
                #  This is Equation (15) on Page 690 of Reference [ 1 ].
                #---------------------------------------------------------------
                   B0  = oneAndHalf_e4 *
                         S0Squared     *
                         C0Squared     *
                         Pn            *
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
                   estimatedGeodeticNorthLatitudeRadians = atan( S1, Cc );

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
                   a1  = sqrt(
                                (
                                  complimentaryEarthEllipticitySquared *
                                  S1Squared
                                )
                                +
                                CcSquared
                             );
                #---------------------------------------------------------------
                #  This is Equation (20) on Page 691 of Reference [ 1 ].
                #---------------------------------------------------------------
                   estimatedGeodeticAltitudeMeters =
                              (
                                (  earthPolarAxisDistanceMeters * Cc ) +
                                (  absZ                         * S1 ) +
                                ( -earthEquatorialRadiusMeters  * a1 )
                              ) / sqrt( CcSquared + S1Squared );
                #}--------------------------------------------------------------
              else
                #{--------------------------------------------------------------
                #  The specified Rectangular coordinates are very near
                #  the polar axis.
                #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                #  Apply exceptional processing for the polar axis
                #  vincinity.
                #---------------------------------------------------------------
                   estimatedGeodeticNorthLatitudeRadians = pi / 2.0;
                   estimatedGeodeticAltitudeMeters       =
                                                 absZ -
                                                 earthPolarRadiusMeters;
                #}--------------------------------------------------------------
               end;
            #-------------------------------------------------------------------
               if( zRectangularMeters < 0.0 )
                #{--------------------------------------------------------------
                #  The specified Rectangular z coordinate is negative.
                #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                #  The specified Rectangular coorindates must be in the
                #  Southern Hemisphere.
                #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                #  Change the sign of the computed Geodetic Latitude.
                #---------------------------------------------------------------
                   estimatedGeodeticNorthLatitudeRadians =
                                         -estimatedGeodeticNorthLatitudeRadians;
                #}--------------------------------------------------------------
               end;
            #-------------------------------------------------------------------
            #  Set the success status return value.
            #-------------------------------------------------------------------
               functionStatus = SUCCESS_STATUS;
            #-------------------------------------------------------------------
               returnValue = [
                               Int( functionStatus ),
                               estimatedGeodeticNorthLatitudeRadians,
                               estimatedGeocentricEastLongitudeRadians,
                               estimatedGeodeticAltitudeMeters             
                             ];
            #}------------------------------------------------------------------
           else
            #{------------------------------------------------------------------
            #  The squared complimentary ellipsoid parameter is invalid.
            #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            #  Generate a purpose message.
            #-------------------------------------------------------------------
               generateConvertEcefToGeodeticPurposeMessage(  );
            #-------------------------------------------------------------------
            #  Generate a usage message.
            #-------------------------------------------------------------------
               generateConvertEcefToGeodeticUsageMessage(  );
            #-------------------------------------------------------------------
            #  Generate an error message.
            #-------------------------------------------------------------------
               formatString01 =
               string(
                       "\n\n\n",
                       "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
                       "%s\n%s\n%s\n",
                       "%s%14.6e\n",
                       "%s\n%s\n%s\n%s\n",
                       "\n\n\n"
                     );
            #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               printFormatted(
                 formatString01,
                 "------------------------------------------------------------",
                 "|",
                 "|  ERROR:",
                 "|",            
                 "|  FUNCTION:  convertEcefToGeodetic",
                 "|",
                 "|    The squared complimentary Earth ellipsoid",
                 "|    parameter value is invalid.",
                 "|",
                 "|    Squared complementary Earth ellipsoid",
                 "|    parameter value is expected to be positive.",
                 "|",
                 "|    Squared complementary Earth ellipsoid",
                 "|    parameter value is:-->",
                 complimentaryEarthEllipticitySquared,
                 "|",
                 "|    This is an error.",
                 "|",
                 "------------------------------------------------------------"
               );
            #-------------------------------------------------------------------
            #  Set the error return value.
            #-------------------------------------------------------------------
               functionStatus = INVALID_COMPLIMENTARY_ELLIPSOIDAL_FLATTENING;
            #-------------------------------------------------------------------
               returnValue    = [
                                   Int( functionStatus ),
                                   NaN64,
                                   NaN64,
                                   NaN64
                                ];
            #}------------------------------------------------------------------
           end;
        #}----------------------------------------------------------------------
       else
        #{----------------------------------------------------------------------
        #  The Earth ellipsoid equatorial radius (major semiaxis length)
        #  parameter value is invalid.
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #  Generate a purpose message.
        #-----------------------------------------------------------------------
           generateConvertEcefToGeodeticPurposeMessage(  );
        #-----------------------------------------------------------------------
        #  Generate a usage message.
        #-----------------------------------------------------------------------
           generateConvertEcefToGeodeticUsageMessage(  );
        #-----------------------------------------------------------------------
        #  Generate an error message.
        #-----------------------------------------------------------------------
           formatString02 =
           string(     
                   "\n\n\n",
                   "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
                   "%s\n%s\n%s\n%s\n",
                   "%s%14.6e\n",
                   "%s\n%s\n%s\n%s\n",
                   "\n\n\n"
                 );
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           printFormatted(
             stdout,
             formatString02,
             "============================================================",
             "|",
             "|  ERROR:",
             "|",
             "|  FUNCTION:  convertEcefToGeodetic",
             "|",
             "|    The specified Earth ellipsoid equatorial radius",
             "|    parameter value is invalid.",
             "|",
             "|    Expected Earth ellipsoid equatorial radius",
             "|    (major semiaxis length) parameter value to be",
             "|    strictly positive.",
             "|",
             "|    The specifiedEarth ellipsoid equatorial radius",
             "|    parameter value is:-->",
             earthEquatorialRadiusMeters,
             "|",
             "|    This is an error.",
             "|",
             "============================================================"
           );
        #-----------------------------------------------------------------------
        #  Set the error return value.
        #-----------------------------------------------------------------------
           functionStatus = INVALID_EQUATORIAL_RADIUS;
        #-----------------------------------------------------------------------
           returnValue    = [
                               Int( functionStatus ),
                               NaN64,
                               NaN64,
                               NaN64
                            ];
        #}----------------------------------------------------------------------
       end;
    #}--------------------------------------------------------------------------
   else
    #{--------------------------------------------------------------------------
    #  The Earth ellipsoidal flattening factor parameter value is invalid.
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #  Generate a purpose message.
    #---------------------------------------------------------------------------
       generateConvertEcefToGeodeticPurposeMessage(  );
    #---------------------------------------------------------------------------
    #  Generate a usage message.
    #---------------------------------------------------------------------------
       generateConvertEcefToGeodeticUsageMessage(  );
    #---------------------------------------------------------------------------
    #  Generate an error message.
    #---------------------------------------------------------------------------
       formatString03 =
       string(     
               "\n\n\n",
               "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
               "%s\n%s\n%s\n%s\n",
               "%s%14.6e\n",
               "%s\n%s\n%s\n%s\n",
               "\n\n\n"
             );
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       printFormatted(
         stdout,
         formatString03,
         "============================================================",
         "|",
         "|  ERROR:",
         "|",
         "|  FUNCTION:  convertEcefToGeodetic",
         "|",
         "|    The specified Earth ellipsoid flattening factor",
         "|    parameter value is invalid.",
         "|",
         "|    Expected Earth ellipsoidal flattening factor",
         "|    parameter value is to be in the interval:",
         "|    [ 0.0, 1.0 ).",
         "|",
         "|    The specified Earth ellipsoidal flattening factor",
         "|    parameter value is:-->",
         earthEllipsoidalFlatteningFactor,
         "|",
         "|    This is an error.",
         "|",
         "============================================================"
       );
    #---------------------------------------------------------------------------
    #  Set the error return value.
    #---------------------------------------------------------------------------
       functionStatus = INVALID_ELLIPSOIDAL_FLATTENING;
    #---------------------------------------------------------------------------
       returnValue    = [
                           Int( functionStatus ),
                           NaN64,
                           NaN64,
                           NaN64
                        ];
    #}--------------------------------------------------------------------------
   end;
#-------------------------------------------------------------------------------
   return( returnValue );
#-------------------------------------------------------------------------------
   end;
#}------------------------------------------------------------------------------
