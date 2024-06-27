//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include "conversionBetweenEcefAndGeodetic.h"

//------------------------------------------------------------------------------
ECEF_TO_GEODETIC_CONVERSION_STATUS
convertEcefToGeodetic
       (
         //-------------------
         // INPUT(s):
         //-------------------
            const double  earthEquatorialRadiusMeters,
            const double  earthEllipsoidalFlatteningFactor,
            const double  xEcefMeters,
            const double  yEcefMeters,
            const double  zEcefMeters,
         //-------------------
         // OUTPUT(s):
         //-------------------
                  double &rEstimatedGeodeticNorthLatitudeRadians,
                  double &rEstimatedGeocentricEastLongitudeRadians,
                  double &rEstimatedGeodeticAltitudeMeters
       )
//==============================================================================
//
//  FUNCTION:
//    convertEcefToGeodetic 
//
//-----------------------------------------------------------------------------
//
//  PURPOSE:
//
//    Convert Earth Centered Earth Fixed (ECEF) retangular coordinates
//    to geodetic coordinates for a specified reference ellipsoid.
//
//-----------------------------------------------------------------------------
//
//  METHOD:
//    [ 1 ] Uses the economic third-order Halley's method to approximate
//          a solution to the general non-linear fourth-order algebraic
//          geodetic equation numerically.
//
//    [ 2 ] Uses only  one iteration of the iterative Halley's method to
//          achieve near double precision accuracy.
//
//    [ 3 ] Uses a technique to avoid division operations which significantly
//          accelerates the backward transformation without degrading the
//          precision.
//
//-----------------------------------------------------------------------------
//
//  INPUT(s):
//     earthEquatorialRadiusMeters
//       Length of Eartch equatorial radius [meters].
//       Also length of Earth ellipsoid semi-major axis.
//       UNITS:  [meters]
//
//     earthEllipsoidalFlatteningFactor
//       Value of Earth ellipsoidal flattening factor.
//       UNITS:  [nondimensional]
//
//     xEcefMeters
//     yEcefMeters
//     zEcefMeters
//       Earth Centered Earth Fixed (ECEF) rectangular coordinates.
//       UNITS:  [meters]
//
//-----------------------------------------------------------------------------
//
//  OUTPUT(s):
//
//     rEstimatedGeodeticNorthLatitudeRadians
//       Reference to a variable to contain the estimated Geodetic
//       North latitude.
//       Northern hemisphere is positive.
//       UNITS:  [radians]
//
//     rEstimatedGeocentricEastLongitudeRadians
//       Reference to a variable to contain the estimated Geocentric
//       East longitude.
//       Eastward is positive.
//       UNITS:  [radians]
//
//     rEstimatedGeodeticAltitudeMeters
//       Reference to a variable to contain the estimated Geodetic altitude
//       above the specified reference ellipsoid.
//       UNITS:  [meters]
//
//-----------------------------------------------------------------------------
//
//  RETURNED VALUE:
//
//     An enumeration of the conversion status:
//        SUCCESSFUL_CONVERSION
//        UNDETERMINED_CONVERSION_STATUS
//        INVALID_ELLIPSOIDAL_FLATTENING
//        INVALID_EQUATORIAL_REDIUS
//
//------------------------------------------------------------------------------
//
//  NOTE(s):
//
//    [ 1 ] This function is based on the FORTRAN subroutine gconv2h by
//          Toshio Fukushima (see References).
//
//------------------------------------------------------------------------------
//
//  AUTHOR(s):
//
//    [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
//           National Astronomical Observatory of Japan (NAOJ)
//           Address:  2-21-1, Ohsawa, Mitaka, Tokyo   181-8588,  Japan
//           Phone:    +81-422-34-3613
//
//------------------------------------------------------------------------------
//
//  REFERENCE(s):
//
//     [ 1 ]  "Transformation from Cartesian to geodetic
//             coordinates accelerated by Halley's method",
//            Toshio Fukushima,
//            J.Geodesy (2006),
//            Volume 79,
//            Pages 689-693
//
//     [ 2 ]  "Fast transform from geocentric to geodetic coordinates",
//            Toshio Fukushima,
//            Journal Of Geodesy (1999),
//            Volume 73,
//            Pages 603–610
//
//     [ 3 ]  "Geometric Geodesy, Part A",
//            "A set of lecture notes which are an introduction to
//             ellipsoidal geometry related to geodesy.",
//            R. E. Deakin and M. N. Hunter,
//            School of Mathematical and Geospatial Sciences,
//            RMIT University,
//            Melbourne, Australia,
//            January 2013
//            www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
//
//    [ 4 ]  'Various parameterizations of "latitude" equation -
//            Cartesian to geodetic coordinates transformation',
//            Marcin Ligas,
//            Journal of Geodetic Science,
//            Pages 87 - 94,
//            2013
//
//    [ 5 ]  "In numerical analysis, Halley's method is a root-finding
//            algorithm used for functions of one real variable with a
//            continuous second derivative.",
//           "The rate of convergence of the iterative Halley's method
//            is cubic.",
//           "There exist multidimensional versions of Halley's method.",
//           wikipedia.org/wiki/Halley's_method`
//
//-----------------------------------------------------------------------------
//
//  USAGE:
//
//    ecefToGeodeticConversionStatus =
//    convertEcefToGeodetic
//           (
//             //-------------------
//             // INPUT(s):
//             //-------------------
//                earthEquatorialRadiusMeters,
//                earthEllipsoidalFlatteningFactor,
//                xEcefMeters,
//                yEcefMeters,
//                zEcefMeters,
//             //-------------------
//             // OUTPUT(s):
//             //-------------------
//                rEstimatedGeodeticNorthLatitudeRadians,
//                rEstimatedGeocentricEastLongitudeRadians,
//                rEstimatedGeodeticAltitudeMeters
//           );
//
//==============================================================================
{
 //-----------------------------------------------------------------------------
    ECEF_TO_GEODETIC_CONVERSION_STATUS
            returnValue = UNDETERMINED_CONVERSION_STATUS;
 //-----------------------------------------------------------------------------
    if(
        ( earthEllipsoidalFlatteningFactor >= 0.0 )
        &&
        ( earthEllipsoidalFlatteningFactor <  1.0 )
      )
      {
       //-----------------------------------------------------------------------
       // The ellipsoidal flattening factor parameter value is valid.
       //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       // Continue validating the specified ellipsoid parameters.
       //-----------------------------------------------------------------------
          if( earthEquatorialRadiusMeters > 0.0 )
            {
             //-----------------------------------------------------------------
             // The Earth ellipsoid equatorial radius (major semiaxis length)
             // parameter value is valid.
             //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             // Determine functions of the ellipsoid parameters.
             //-----------------------------------------------------------------
                const double eps           = 1.0e-16;
             //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                const double aEps          = earthEquatorialRadiusMeters * eps;
                const double aEpsSquared   = aEps                        * aEps;
             //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                const double earthEllipticitySquared =
                                     ( 2.0 -
                                       earthEllipsoidalFlatteningFactor ) *
                                       earthEllipsoidalFlatteningFactor;
                const double earthEllipticityForth   =
                                       earthEllipticitySquared *
                                       earthEllipticitySquared;
                const double oneAndHalf_e4 = 1.5 *
                                             earthEllipticityForth;
                const double complimentaryEarthEllipticitySquared
                                           = 1.0 - earthEllipticitySquared;
             //-----------------------------------------------------------------
             //
             // NOTE:
             //
             //   The fact that the ellipsoidal flattening factor parameter is
             //   valid guarantees that the squared complementary ellipsoidal
             //   parameter value ecSquared is strictly positive.
             //   We will check the the ecSquared value is strictly positive
             //   here anyway.
             //
             //-----------------------------------------------------------------
                if( complimentaryEarthEllipticitySquared > 0.0 )
                  {
                   //-----------------------------------------------------------
                   // The squared complementary ellipsoid parameter is valid.
                   //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                   // Proceed with the geodetic computation.
                   //-----------------------------------------------------------
                      const double complimentaryEarthEllipticity
                                               =
                                   sqrt( complimentaryEarthEllipticitySquared );
                      const double earthPolarRadiusMeters =
                                             complimentaryEarthEllipticity *
                                             earthEquatorialRadiusMeters;
                   //-----------------------------------------------------------
                   // Distance from polar axis squared.
                   //-----------------------------------------------------------
                      const double earthPolarAxisDistanceSquared =
                                              ( xEcefMeters * xEcefMeters ) +
                                              ( yEcefMeters * yEcefMeters );
                   //-----------------------------------------------------------
                   // Determine Geocentric Longitude [radians].
                   //-----------------------------------------------------------
                      rEstimatedGeocentricEastLongitudeRadians =
                           ( earthPolarAxisDistanceSquared > 0.0 ) ?
                                                atan2( yEcefMeters,
                                                       xEcefMeters ) : 0.0;
                   //-----------------------------------------------------------
                   // Unsigned Geocentric z-coordinate.
                   //-----------------------------------------------------------
                      const
                       double absZ = abs( zEcefMeters );
                   //-----------------------------------------------------------
                      if( earthPolarAxisDistanceSquared > aEpsSquared )
                        {
                         //-----------------------------------------------------
                         // The specified Geocentric coordinates are
                         // sufficiently far from the polar axis for
                         // normal geodetic processing.
                         //- - - - - - - - - - - - - - - - - - - - - - - - - - -
                         // Determine distance from the polar axis.
                         //-----------------------------------------------------
                            const
                             double earthPolarAxisDistanceMeters =
                                         sqrt( earthPolarAxisDistanceSquared );
                         //-----------------------------------------------------
                         //
                         // Perform normalization.
                         //
                         //-----------------------------------------------------
                         // This is from Equation (2)  on Page 690 and
                         //              Equation (17) on Page 691 of
                         // Reference [ 1 ].
                         // Here the factor of ec in Equation ( 2 ) is missing.
                         //-----------------------------------------------------
                            const
                             double S0 = absZ / earthEquatorialRadiusMeters;
                         //-----------------------------------------------------
                         // This is Equation (2) on Page 690 of Reference
                         // [ 1 ].
                         //-----------------------------------------------------
                            const
                             double Pn = earthPolarAxisDistanceMeters /
                                         earthEquatorialRadiusMeters;
                            const
                             double zc = complimentaryEarthEllipticity * S0;
                         //=====================================================
                         //
                         // Prepare the Newton correction factors.
                         //
                         //=====================================================

                         //-----------------------------------------------------
                         // This is Equation (17) on Page 691 of Reference
                         // [ 1 ].
                         //-----------------------------------------------------
                            const
                             double C0        = complimentaryEarthEllipticity
                                                *
                                                Pn;
                         //-----------------------------------------------------
                            const
                             double C0Squared = C0 * C0;
                            const
                             double C0Cubed   = C0 * C0Squared;
                         //-----------------------------------------------------
                            const
                             double S0Squared = S0 * S0;
                            const
                             double S0Cubed   = S0 * S0Squared;
                         //-----------------------------------------------------
                         // This is Equation (14) on Page 690 of Reference
                         // [ 1 ].
                         //-----------------------------------------------------
                            const
                             double A0Squared = C0Squared + S0Squared;
                            const
                             double A0        = sqrt( A0Squared );
                            const
                             double A0Cubed   = A0 * A0Squared;
                         //-----------------------------------------------------
                         // This is Equation (12) on Page 690 of Reference
                         // [ 1 ].
                         //-----------------------------------------------------
                            const
                             double D0  =
                                    (  zc                      * A0Cubed )
                                    +
                                    (  earthEllipticitySquared * S0Cubed );
                         //-----------------------------------------------------
                         // This is Equation (13) on Page 690 of Reference
                         // [ 1 ].
                         //-----------------------------------------------------
                            const
                             double F0  =
                                    (  Pn                      * A0Cubed )
                                    +
                                    ( -earthEllipticitySquared * C0Cubed );

                         //=====================================================
                         //
                         // Prepare the Halley correction factors.
                         //
                         //=====================================================

                         //-----------------------------------------------------
                         // This is Equation (15) on Page 690 of Reference
                         // [ 1 ].
                         //-----------------------------------------------------
                            const
                             double B0  =
                                    oneAndHalf_e4 *
                                    S0Squared     *
                                    C0Squared     *
                                    Pn            *
                                    ( A0 - complimentaryEarthEllipticity );
                         //-----------------------------------------------------
                         // This is Equation (10) on Page 690 of Reference
                         // [ 1 ].
                         //-----------------------------------------------------
                            const
                             double S1  = ( D0 * F0 ) + ( -B0 * S0 );
                         //-----------------------------------------------------
                         // This is Equation (11) on Page 690 of Reference
                         // [ 1 ].
                         //-----------------------------------------------------
                            const
                             double C1  = ( F0 * F0 ) + ( -B0 * C0 );
                         //-----------------------------------------------------
                         // This is Equation (21) on Page 691 of Reference
                         // [ 1 ].
                         //-----------------------------------------------------
                            const
                             double Cc  = complimentaryEarthEllipticity * C1;

                         //=====================================================
                         //
                         // Evaluate geodetic latitude.
                         //
                         //=====================================================

                         //-----------------------------------------------------
                         // This is Equation (19) on Page 691 of
                         // Reference [ 1 ].
                         //-----------------------------------------------------
                            rEstimatedGeodeticNorthLatitudeRadians =
                                                           atan2( S1, Cc );

                         //=====================================================
                         //
                         // Evaluate geodetic altitude.
                         // 
                         //=====================================================
                            const
                             double S1Squared = S1 * S1;
                            const
                             double CcSquared = Cc * Cc;
                         //- - - - - - - - - - - - - - - - - - - - - - - - - - -
                         // The quantity a1 is ec times A1.
                         // The quantity A1 is given by Equation (14) on
                         // Page 690 of Reference [ 1 ].
                         // - - - - - - - - - - - - - - - - - - - - - - - - - - 
                            const
                             double a1  =
                             sqrt(
                                   (
                                     complimentaryEarthEllipticitySquared *
                                     S1Squared
                                   )
                                   +
                                   CcSquared
                                 );
                         //- - - - - - - - - - - - - - - - - - - - - - - - - - -
                         // This is Equation (20) on Page 691 of Reference
                         // [ 1 ].
                         //- - - - - - - - - - - - - - - - - - - - - - - - - - -
                            rEstimatedGeodeticAltitudeMeters
                                = (
                                    (  earthPolarAxisDistanceMeters * Cc ) +
                                    (  absZ                         * S1 ) +
                                    ( -earthEquatorialRadiusMeters  * a1 )
                                  ) / sqrt( CcSquared + S1Squared );
                         //-----------------------------------------------------
                        }
                      else
                        {
                         //-----------------------------------------------------
                         // The specified Geocentric coordinates are very near
                         // the polar axis.
                         //- - - - - - - - - - - - - - - - - - - - - - - - - - -
                         // Apply exceptional processing for the polar axis
                         // vincinity.
                         //-----------------------------------------------------
                            const
                            double
                            piOverTwo         = 2.0 * atan( 1.0 );
                         //- - - - - - - - - - - - - - - - - - - - - - - - - - -
                            rEstimatedGeodeticNorthLatitudeRadians = piOverTwo;
                            rEstimatedGeodeticAltitudeMeters =
                                              absZ -
                                              earthPolarRadiusMeters;
                         //-----------------------------------------------------
                        };
                   //-----------------------------------------------------------
                      if( zEcefMeters < 0.0 )
                        {
                         //-----------------------------------------------------
                         // The specified Geocentric z coordinate is negative.
                         //- - - - - - - - - - - - - - - - - - - - - - - - - - -
                         // The specified Geocentric coorindates must be in the
                         // Southern Hemisphere.
                         //- - - - - - - - - - - - - - - - - - - - - - - - - - -
                         // Change the sign of the computed Geodetic Latitude.
                         //-----------------------------------------------------
                            rEstimatedGeodeticNorthLatitudeRadians =
                                       -rEstimatedGeodeticNorthLatitudeRadians;
                         //-----------------------------------------------------
                        };
                   //-----------------------------------------------------------
                   // Set the success status return value.
                   //-----------------------------------------------------------
                      returnValue = SUCCESSFUL_CONVERSION;
                   //-----------------------------------------------------------
                  }
                else
                  {
                   //-----------------------------------------------------------
                   // The squared complementary Earth ellipsoid parameter
                   // value is invalid.
                   //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                   // Generate a purpose message.
                   //-----------------------------------------------------------
                      generateConvertEcefToGeodeticPurposeMessage(  );
                   //-----------------------------------------------------------
                   // Generate a usage message.
                   //-----------------------------------------------------------
                      generateConvertEcefToGeodeticUsageMessage(  );
                   //-----------------------------------------------------------
                   // Generate an error message.
                   //-----------------------------------------------------------
                      fprintf
                      (
                        stdout,
                        "\n\n\n"
                        "%s%s\n"
                        "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
                        "%s%14.6e\n",
                        "%s\n%s\n%s\n"
                        "%s%s\n",
                        "\n\n\n",
                        "================================================",
                        "============",
                        "|",
                        "|  ERROR:",
                        "|",
                        "|    The squared complementary Earth ellipsoid",
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
                        "================================================",
                        "============"
                      );
                   //-----------------------------------------------------------
                   // Set the error function status return value.
                   //-----------------------------------------------------------
                      returnValue = INVALID_ELLIPSOIDAL_FLATTENING;
                   //-----------------------------------------------------------
                  };
             //-----------------------------------------------------------------
            }
          else
            {
             //-----------------------------------------------------------------
             // The ellipsoid equatorial radius (major semiaxis length)
             // parameter value is invalid.
             //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
             // Generate a purpose message.
             //-----------------------------------------------------------------
                generateConvertEcefToGeodeticPurposeMessage(  );
             //-----------------------------------------------------------------
             // Generate a usage message.
             //-----------------------------------------------------------------
                generateConvertEcefToGeodeticUsageMessage(  );
             //-----------------------------------------------------------------
             // Generate an error message.
             //-----------------------------------------------------------------
                fprintf
                (
                  stdout,
                  "\n\n\n"
                  "%s%s\n"
                  "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
                  "%s%14.6e\n" 
                  "%s\n%s\n%s\n"
                  "%s%s\n" 
                  "\n\n\n",
                  "======================================================",
                  "======",
                  "|",
                  "|  ERROR:",
                  "|",
                  "|    The specified Earth equatorial radius (major",
                  "|    semiaxis length) parameter value is invalid.",
                  "|",
                  "|    Expected Earth equatorial radius value to be",
                  "|    strictly positive.",
                  "|",
                  "|    Specified Earth equatorial radius parameter",
                  "|    value is:-->",
                  earthEquatorialRadiusMeters,
                  "|",
                  "|    This is an error.",
                  "|",
                  "======================================================",
                  "======"
                );
             //-----------------------------------------------------------------
             // Set the error function status return value.
             //-----------------------------------------------------------------
                returnValue = INVALID_EQUATORIAL_RADIUS;
            //------------------------------------------------------------------
            };
       //-----------------------------------------------------------------------
      }
    else
      {
       //-----------------------------------------------------------------------
       // The specified Earth ellipsoidal flattening factor parameter value
       // is invalid.
       //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       // Generate a purpose message.
       //-----------------------------------------------------------------------
          generateConvertEcefToGeodeticPurposeMessage(  );
       //-----------------------------------------------------------------------
       // Generate a usage message.
       //-----------------------------------------------------------------------
          generateConvertEcefToGeodeticUsageMessage(  );
       //-----------------------------------------------------------------------
       // Generate an error message.
       //-----------------------------------------------------------------------
          fprintf
          (
            stdout,
            "\n\n\n"
            "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
            "%s\n"
            "%s%14.6e\n",
            "%s\n%s\n%s\n%s\n"
            "\n\n\n",
            "============================================================",
            "|",
            "|  ERROR:",
            "|",
            "|    The specified Earth ellipsoidal flattening factor",
            "|    parameter value is invalid.",
            "|",
            "|    Expected Earth ellipsoidal flattening factor",
            "|    parameter value to be in the interval:  [ 0.0, 1.0 ).",
            "|",
            "|    Specified Earth ellipsoidal flattening factor",
            "|    parameter value is:-->",
            earthEllipsoidalFlatteningFactor,
            "|",
            "|    This is an error.",
            "|",
            "============================================================"
          );
       //-----------------------------------------------------------------------
       // Set the error function status return value.
       //-----------------------------------------------------------------------
          returnValue = INVALID_ELLIPSOIDAL_FLATTENING;
       //-----------------------------------------------------------------------
      }; 
 //----------------------------------------------------------------------------- 
    return( returnValue );
 //-----------------------------------------------------------------------------
}
//==============================================================================
