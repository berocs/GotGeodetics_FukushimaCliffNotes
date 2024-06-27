//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include "conversionBetweenEcefAndGeodetic.h"

//------------------------------------------------------------------------------
void
generateConvertGeodeticToEcefPurposeMessage(  )
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
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n"                           
      "\n\n\n",
      "====================================================================",
      "|",
      "|  FUNCTION:",
      "|    convertGeodeticToEcef",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  PURPOSE:",
      "|",
      "|    Convert:",
      "|      Geodetic   Latitude,",
      "|      Geocentric Longitude",
      "|      Geodetic   Altitude",
      "|    to Earth Centered Earth Fixed (ECEF) rectangular coordinates.",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  INPUTS:",
      "|",
      "|     earthEquatorialRadiusMeters",
      "|       Length of Earth equatorial radius",
      "|       Also length of Earth ellipsoid semi-major axis.",
      "|       UNITS:  [meters]",
      "|",
      "|     earthEllipsoidalEccentricitySquared",
      "|       Earth ellipsoid eccentricity squared.",
      "|       UNITS:  [nondimensional]",
      "|",
      "|     geodeticNorthLatitudeRadians",
      "|       The North geodetic latitude.",
      "|       Northern hemisphere is positive.",
      "|       UNITS:  [radians]",
      "|",
      "|     geocentricEastLongitudeRadians",
      "|       The East Geocentric longitude.",
      "|       Eastward is positive.",
      "|       UNITS:  [radians]",
      "|",
      "|     geodeticAltitudeMeters",
      "|       The geodetic altitude above the specified reference",
      "|       ellipsoid.",
      "|       UNITS:  [meters]",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  OUTPUT:",
      "|",
      "|     rXEcefMeters",
      "|       Reference to a variable to contain the X ECEF position.",
      "|       UNITS:  [meters]",
      "|",
      "|     rYEcefMeters",
      "|       Reference to a variable to contain the Y ECEF position.",
      "|       UNITS:  [meters]",
      "|",
      "|     rZEcefMeters",
      "|       Reference to a variable to contain the Z ECEF position.",
      "|       UNITS:  [meters]",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  RETURNED VALUE:",
      "|",
      "|    None.",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  REFERENCE(s):",
      "|",
      "|     [ 1 ]  'Geographic coordinate conversion',",
      "|            'Coordinate system conversion',",
      "|            'From geodetic to ECEF coordinates'",
      "|            https://en.wikipedia.org/wiki/",
      "|            Geographic_coordinate_conversion",
      "|",
      "|     [ 2 ]  'Geometric Geodesy, Part A',",
      "|            'A set of lecture notes which are an introduction",
      "|             to ellipsoidal geometry related to geodesy.',",
      "|            R. E. Deakin and M. N. Hunter,",
      "|            School of Mathematical and Geospatial Sciences,",
      "|            RMIT University,",
      "|            Melbourne, Australia,",
      "|            January 2013",
      "|            www.mygeodesy.id.au/documents/Geometric%20Geodesy",
      "|            %20A(2013).pdf",
      "|",
      "===================================================================="
    );

//------------------------------------------------------------------------------
   return;
//------------------------------------------------------------------------------
}
//==============================================================================

