//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include "conversionBetweenEcefAndGeodetic.h"

//------------------------------------------------------------------------------
void
generateConvertEcefToGeodeticPurposeMessage(  )
{
//------------------------------------------------------------------------------
   fprintf
    (
      stdout,
      "\n\n\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n"
      "\n\n\n",
      "====================================================================",
      "|",
      "|  FUNCTION:",
      "|",
      "|    convertEcefToGeodetic",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "| PURPOSE:",
      "|",
      "|    Convert Earth Centered Earth Fixed (ECEF) retangular",
      "|    coordinates to geodetic coordinates for a specified",
      "|    reference ellipsoid.",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  METHOD:",
      "|",
      "|    [ 1 ] Uses the economic third-order Halley's method to",
      "|          approximate a solution for the general non-linear",
      "|          geodetic equation numerically.",
      "|",
      "|    [ 2 ] Uses only one iteration of the iterative Halley's",
      "|          method to achieve near double precision accuracy.",
      "|",
      "|    [ 3 ] Uses a technique to avoid division operations which",
      "|          significantly accelerates the backward transformation",
      "|          without degrading the precision.",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  INPUTS:",
      "|",
      "|    earthEquatorialRadiusMeters",
      "|      Length of Earth equatorial radius",
      "|      Also length of Earth ellipsoid semi-major axis.",
      "|      UNITS:  [meters]",
      "|",
      "|    earthEllipsoidalFlatteningFactor",
      "|      Value of Earth ellipsoidal flattening factor, f.",
      "|      UNITS:  [nondimensional]",
      "|",
      "|    xEcefMeters",
      "|    yEcefMeters",
      "|    zEcefMeters",
      "|      Earth Centered Earth Fixed (ECEF) rectangular coordinates",
      "|      UNITS:  [meters]",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  OUTPUTS:",
      "|",
      "|    estimatedGeodeticNorthLatitudeRadians",
      "|      A variable to contain the estimated North Geodetic latitude.",
      "|      Northern hemisphere is positive.",
      "|      UNITS: [radians]",
      "|",
      "|    estimatedGeocentricEastLongitudeRadians",
      "|      A variable to contain the  estimated East Geocentric",
      "|      longitude.",
      "|      Eastward is positive.",
      "|      UNITS:  [radians]",
      "|",
      "|    estimatedGeodeticAltitudeMeters",
      "|      A variable to contain the estimated Geodetic altitude",
      "|      above the specified reference ellipsoid.",
      "|      UNITS:  [meters]",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  RETURN VALUE:",
      "|",
      "|    ecefToGeodeticConversionStatusEnumeration",
      "|      A ECEF_TO_GEODETIC_CONVERSION_STATUS enumeration value",
      "|      for the status of the ECEF to geodetic conversion function",
      "|      results.",
      "|",
      "|        CONVERSION_SUCCESSFUL",
      "|          Conversion was successful.",
      "|",
      "|        UNDETERMINED_CONVERSION_STATUS",
      "|          Conversion status undetermined.",
      "|",
      "|        INVALID_EARTH_ELLIPSOIDAL_FLATTENING",
      "|          Unacceptable value for Earth ellipsoidal",
      "|          flattening factor.",
      "|",
      "|        INVALID_EARTH_EQUATORIAL_RADIUS",
      "|          Unacceptable value for Earth equatorial",
      "|          radius length.",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  NOTE(s):",
      "|",
      "|    [ 1 ] This function is based on the FORTRAN subroutine gconv2h",
      "|          by Toshio Fukushima (see References).",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  AUTHOR(s):",
      "|",
      "|    [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>",
      "|           National Astronomical Observatory of Japan (NAOJ)",
      "|           Address:  2-21-1, Ohsawa, Mitaka, Tokyo 181-8588, Japan",
      "|           Phone:    +81-422-34-3613",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  REFERENCE(s):",
      "|",
      "|    [ 1 ]  'Transformation from Cartesian to geodetic",
      "|            coordinates accelerated by Halley's method",
      "|           Toshio Fukushima,",
      "|           J.Geodesy (2006),",
      "|           Volume 79,",
      "|           Pages 689-693",
      "|",
      "|    [ 2 ]  'Fast transform from geocentric to geodetic coordinates'",
      "|           Toshio Fukushima,",
      "|           Journal Of Geodesy (1999),",
      "|           Volume 73,",
      "|           Pages 603–610",
      "|",
      "|    [ 3 ]  'Geometric Geodesy, Part A',",
      "|           'A set of lecture notes which are an introduction to",
      "|            ellipsoidal geometry related to geodesy.",
      "|           R. E. Deakin and M. N. Hunter,",
      "|           School of Mathematical and Geospatial Sciences,",
      "|           RMIT University,",
      "|           Melbourne, Australia,",
      "|           January 2013",
      "|           www.mygeodesy.id.au/documents/Geometric",
      "|               %20Geodesy%20A(2013).pdf",
      "|",
      "|    [ 4 ]  'Various parameterizations of 'latitude' equation -",
      "|            Cartesian to geodetic coordinates transformation',",
      "|            Marcin Ligas,",
      "|            Journal of Geodetic Science,",
      "|            Pages 87 - 94,",
      "|            2013",
      "|",
      "|    [ 5 ]  'In numerical analysis, Halley's method is a root-",
      "|            finding algorithm used for functions of one real",
      "|            variable with a continuous second derivative.",
      "|           'The rate of convergence of the iterative Halley's",
      "|            method is cubic.',",
      "|           'There exist multidimensional versions of Halley's",
      "|            method.",
      "|            wikipedia.org/wiki/Halley's_method",
      "|",
      "===================================================================="
    );

//------------------------------------------------------------------------------
   return;
//------------------------------------------------------------------------------
}
//==============================================================================

