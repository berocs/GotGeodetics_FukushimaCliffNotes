//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include "conversionBetweenEcefAndGeodetic.h"

//------------------------------------------------------------------------------
void
convertGeodeticToEcef
       (
        //----------------
        // INPUT(s):
        //----------------
           const double   earthEquatorialRadiusMeters,
           const double   earthEllipsoidalEccentricitySquared,
           const double   geodeticNorthLatitudeRadians,
           const double   geocentricEastLongitudeRadians,
           const double   geodeticAltitudeMeters,
        //----------------
        // OUTPUT(s):
        //----------------
                 double & rXEcefMeters,
                 double & rYEcefMeters,
                 double & rZEcefMeters
       )
//==============================================================================
//
//  FUNCTION:
//
//    convertGeodeticToEcef
//
//------------------------------------------------------------------------------
//
//  PURPOSE:
//
//    Convert:
//      Geodetic   Latitude,
//      Geocentric Longitude
//      Geodetic   Altitude
//    to Earth Centered Earth Fixed (ECEF) rectangular coordinates.
//
//------------------------------------------------------------------------------
//
//  INPUTS:
//
//     earthEquatorialRadiusMeters
//       Length of Earth equatorial radius
//       Also length of Earth ellipsoid semi-major axis.
//       UNITS:  [meters]
//
//     earthEllipsoidalEccentricitySquared
//       Earth ellipsoid eccentricity squared.
//       UNITS:  [nondimensional]
//
//     geodeticNorthLatitudeRadians
//       The North geodetic latitude.
//       Northern hemisphere is positive.
//       UNITS:  [radians]
//
//     geocentricEastLongitudeRadians
//       The East Geocentric longitude.
//       Eastward is positive.
//       UNITS:  [radians]
//
//     geodeticAltitudeMeters
//       The geodetic altitude above the specified reference ellipsoid.
//       UNITS:  [meters]
//
//------------------------------------------------------------------------------
//
//  OUTPUT:
//
//     rXEcefMeters
//       Reference to a variable to contain the X ECEF position.
//       UNITS:  [meters]
//
//     rYEcefMeters
//       Reference to a variable to contain the Y ECEF position.
//       UNITS:  [meters]
//
//     rZEcefMeters
//       Reference to a variable to contain the Z ECEF position.
//       UNITS:  [meters]
//
//------------------------------------------------------------------------------
//
//  RETURNED VALUE:
//
//    None.
//
//------------------------------------------------------------------------------
//
//  REFERENCE(s):
//
//     [ 1 ]  "Geographic coordinate conversion",
//            "Coordinate system conversion",
//            "From geodetic to ECEF coordinates"
//            https://en.wikipedia.org/wiki/Geographic_coordinate_conversion
//
//     [ 2 ]  "Geometric Geodesy, Part A",
//            "A set of lecture notes which are an introduction to
//             ellipsoidal geometry related to geodesy.",
//            R. E. Deakin and M. N. Hunter,
//            School of Mathematical and Geospatial Sciences,
//            RMIT University,
//            Melbourne, Australia,
//            January 2013
//            www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
//
//------------------------------------------------------------------------------
//
//  USAGE:
//
//    convertGeodeticToEcef
//           (
//            //----------------
//            // INPUT(s):
//            //----------------
//               earthEquatorialRadiusMeters,
//               earthEllipsoidalEccentricitySquared,
//               geodeticNorthLatitudeRadians,
//               geocentricEastLongitudeRadians,
//               geodeticAltitudeMeters,
//            //----------------
//            // OUTPUT(s):
//            //----------------
//               rXEcefMeters,
//               rYEcefMeters,
//               rZEcefMeters
//           );
//
//==============================================================================
{
 //-----------------------------------------------------------------------------
    const
    double
        sineOfGeodeticNorthLatitude   = sin( geodeticNorthLatitudeRadians   );
    const
    double
      cosineOfGeodeticNorthLatitude   = cos( geodeticNorthLatitudeRadians   );
 //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    const
    double
        sineOfGeocentricEastLongitude = sin( geocentricEastLongitudeRadians );
    const
    double
      cosineOfGeocentricEastLongitude = cos( geocentricEastLongitudeRadians );
 //-----------------------------------------------------------------------------
 //
 // NOTE(s):
 //
 //   [ 1 ]  The value of the prime vertical radius of curvature, N, is
 //          derived in Equation (48) of Section 1.1.6
 //          "Geometry of the ellipse" pages 12 through 15 of
 //          Reference [2].
 //
 //-----------------------------------------------------------------------------
    const
    double
      N    = earthEquatorialRadiusMeters /
             sqrt(
                   1.0E0 +
                   (
                     -earthEllipsoidalEccentricitySquared *
                      sineOfGeodeticNorthLatitude         *
                      sineOfGeodeticNorthLatitude
                   )
                 );
 //-----------------------------------------------------------------------------
    const
    double
      rho  = N + geodeticAltitudeMeters;
    const
    double
      rhoz = ( ( 1.0E0 - earthEllipsoidalEccentricitySquared ) * N ) +
             geodeticAltitudeMeters;
 //-----------------------------------------------------------------------------
 // Check the length quantities.
 //-----------------------------------------------------------------------------
    if(
        ( rho  > 0.0E0 ) &&
        ( rhoz > 0.0E0 )
      )
      {
       //-----------------------------------------------------------------------
       // The length quantities are all positive.
       //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       // Continue the computation of ECEF retangular coordinates.
       //
       // NOTE(s):
       //
       //   [ 1 ]  The Earth Centered Earth Fixed (ECEF) coordinates
       //          { x, y, z } are computed via Equation (277) on page 94
       //          Section 2.1
       //          "Cartesian coords x,y,z given geodetic coords"
       //          of Reference [2].
       //
       //   [ 2 ]  The Earth Centered Earth Fixed (ECEF) coordinates
       //          { x, y, z } are derived on pages 92, 93 and 94 of
       //          Chapter 2
       //          "Transformations Between Cartesian Coordinates x,y,z
       //           and Geodetic Coordinates"
       //          of Reference [2].
       //
       //-----------------------------------------------------------------------
          const
          double
          r            = rho  * cosineOfGeodeticNorthLatitude;
       //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          rXEcefMeters = r    * cosineOfGeocentricEastLongitude;
          rYEcefMeters = r    *   sineOfGeocentricEastLongitude;
          rZEcefMeters = rhoz *   sineOfGeodeticNorthLatitude;
       //-----------------------------------------------------------------------
      }
    else
      {
       //-----------------------------------------------------------------------
       // The length quantities are not all positive.
       //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       // Generate a purpose message.
       //-----------------------------------------------------------------------
          generateConvertGeodeticToEcefPurposeMessage(  );
       //-----------------------------------------------------------------------
       // Generate a usage message.
       //-----------------------------------------------------------------------
          generateConvertGeodeticToEcefUsageMessage(  );
       //-----------------------------------------------------------------------
       // Generate an error message.
       //-----------------------------------------------------------------------
          fprintf
          (
            stdout,
            "\n\n\n"
            "%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
            "%s%14.6e\n"
            "%s%14.6e\n"
            "%s\n%s\n%s\n%s\n"
            "\n\n\n",
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
       //-----------------------------------------------------------------------
       // Assign invalid values to the output arguments.
       //-----------------------------------------------------------------------
          rXEcefMeters = NAN;
          rYEcefMeters = NAN;
          rZEcefMeters = NAN;
       //-----------------------------------------------------------------------
      }; 
 //-----------------------------------------------------------------------------
    return;
 //-----------------------------------------------------------------------------
}

//==============================================================================
