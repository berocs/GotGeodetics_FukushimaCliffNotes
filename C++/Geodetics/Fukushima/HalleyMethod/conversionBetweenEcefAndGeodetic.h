//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#ifndef CONVERSION_BETWEEN_ECEF_AND_GEODETIC_H
     //-------------------------------------------------------------------------
#       define CONVERSION_BETWEEN_ECEF_AND_GEODETIC_H

#       include <math.h>
#       include <stdio.h>

#       include <algorithm>

     //-------------------------------------------------------------------------
        enum
        ECEF_TO_GEODETIC_CONVERSION_STATUS
          {
            SUCCESSFUL_CONVERSION,
            UNDETERMINED_CONVERSION_STATUS,
            INVALID_ELLIPSOIDAL_FLATTENING,
            INVALID_EQUATORIAL_RADIUS
          };
     //-------------------------------------------------------------------------
        void
        generateTestProgramPurposeMessage(  );
     //-------------------------------------------------------------------------
        void
        generateTestProgramOutputHeader
                (
                  const double specifiedFixedTrueEastGeocentricLongitudeDegrees
                );
     //-------------------------------------------------------------------------
        void
        generateConvertEcefToGeodeticPurposeMessage(  );
     //-------------------------------------------------------------------------
        void
        generateConvertEcefToGeodeticUsageMessage(  );
     //-------------------------------------------------------------------------
        void
        generateConvertGeodeticToEcefPurposeMessage(  );
     //-------------------------------------------------------------------------
        void
        generateConvertGeodeticToEcefUsageMessage(  );
     //-------------------------------------------------------------------------
     //
     //  FUNCTION:
     //    convertEcefToGeodetic 
     //
     //-------------------------------------------------------------------------
     //
     //  PURPOSE:
     //    Convert Earth Centered Earth Fixed (ECEF) retangular coordinates
     //    to geodetic coordinates for a specified reference ellipsoid.
     //
     //-------------------------------------------------------------------------
     //
     //  METHOD:
     //    [ 1 ] Uses the economic third-order Halley's method to approximate
     //          a solution to the general non-linear fourth-order algebraic
     //          geodetic equation numerically.
     //
     //    [ 2 ] Uses only  one iteration of the iterative Halley's method to
     //          achieve full double precision accuracy.
     //
     //    [ 3 ] Uses a technique to avoid division operations which
     //          significantly accelerates the backward transformation
     //          without degrading the precision.
     //
     //-------------------------------------------------------------------------
     //
     //  INPUTS:
     //
     //     earthEquatorialRadiusMeters
     //       Length of Eartch equatorial radius [meters].
     //       Also length of Earth ellipsoid semi-major axis.
     //       UNITS:  [meters]
     //       (See Notes 2,4)
     //
     //     earthEllipsoidalFlatteningFactor
     //       Value of Earth ellipsoidal flattening factor.
     //       UNITS:  [nondimensional]
     //       (See Note 3)
     //
     //     xEcefMeters
     //     yEcefMeters
     //     zEcefMeters
     //       Geocentric rectangular coordinates
     //       UNITS:  [meters]
     //
     //-------------------------------------------------------------------------
     //
     //  OUTPUT:
     //
     //     rGeodeticNorthLatitudeRadians
     //       Reference to a variable to contain the estimated Geodetic
     //       North latitude.
     //       Northern hemisphere is positive.
     //       UNITS:  [radians]
     //
     //     rEstimatedGeocentricEastLongitudeRadians
     //       Reference to a variable to contain the estimated East Geocentric
     //       longitude.
     //       Eastward is positive.
     //       UNITS:  [radians]
     //
     //     rEstimatedGeodeticAltitudeMeters
     //       Reference to a variable to contain the estimated Geodetic
     //       altitude above the specified reference ellipsoid.
     //       UNITS:  [meters]
     //
     //-------------------------------------------------------------------------
     //
     //  RETURNED VALUE:
     //
     //     Conversion status:
     //        SUCCESSFUL_CONVERSION
     //        UNDETERMINED_CONVERSION_STATUS
     //        INVALID_ELLIPSOIDAL_FLATTENING
     //        INVALID_EQUATORIAL_REDIUS
     //
     //-------------------------------------------------------------------------
     //
     //  NOTE(s):
     //
     //    [ 1 ] This function is based on the FORTRAN subroutine gconv2h by
     //          Toshio Fukushima (see References).
     //
     //    [ 2 ] The specified equatorial radius length can be in any units,
     //          but meters is the conventional choice.
     //
     //    [ 3 ] The specified ellipsoidal flattening factor is (for the Earth)
     //          a value around 0.00335, (i.e. around 1/298).
     //
     //-------------------------------------------------------------------------
     //
     //  AUTHOR(s):
     //
     //    [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
     //           National Astronomical Observatory of Japan (NAOJ)
     //           Address:  2-21-1, Ohsawa, Mitaka, Tokyo   181-8588,  Japan
     //           Phone:    +81-422-34-3613
     //
     //-------------------------------------------------------------------------
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
     //            www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A
     //            (2013).pdf
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
     //
     //-------------------------------------------------------------------------
        ECEF_TO_GEODETIC_CONVERSION_STATUS
        convertEcefToGeodetic
               (
                 //-------------------
                 // INPUT(s):
                 //-------------------
                    const double  earthEquatorialRadiusMeters,
                    const double  ellipsoidalFlatteningFactor,
                    const double  xEcefMeters,
                    const double  yEcefMeters,
                    const double  zEcefMeters,
                 //-------------------
                 // OUTPUT(s):
                 //-------------------
                          double &rGeodeticNorthLatitudeRadians,
                          double &rGeocentricEastLongitudeRadians,
                          double &rGeodeticAltitudeMeters
               );
     //-------------------------------------------------------------------------
     //
     //
     //  FUNCTION:
     //    convertGeodeticToEcef
     //
     //-------------------------------------------------------------------------
     //
     //  PURPOSE:
     //
     //    Convert:
     //      Geodetic   Latitude,
     //      Geocentric Longitude
     //      Geodetic   Altitude
     //    to Earth Centered Earth Fixed (ECEF) rectangular coordinates.
     //
     //-------------------------------------------------------------------------
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
     //-------------------------------------------------------------------------
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
     //-------------------------------------------------------------------------
     //
     //  RETURNED VALUE:
     //
     //    None.
     //
     //-------------------------------------------------------------------------
     //
     //  REFERENCE(s):
     //
     //     [ 1 ]  "Geographic coordinate conversion",
     //            "Coordinate system conversion",
     //            "From geodetic to ECEF coordinates"
     //            https://en.wikipedia.org/wiki/
     //            Geographic_coordinate_conversion
     //
     //     [ 2 ]  "Geometric Geodesy, Part A",
     //            "A set of lecture notes which are an introduction to
     //             ellipsoidal geometry related to geodesy.",
     //            R. E. Deakin and M. N. Hunter,
     //            School of Mathematical and Geospatial Sciences,
     //            RMIT University,
     //            Melbourne, Australia,
     //            January 2013
     //            www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A
     //            (2013).pdf
     //
     //-------------------------------------------------------------------------
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
               );
     //-------------------------------------------------------------------------
#endif
//==============================================================================

