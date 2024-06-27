//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include "conversionBetweenEcefAndGeodetic.h"

//==============================================================================
void
generateTestProgramOutputHeader
        (
          const double specifiedFixedTrueEastGeocentricLongitudeDegrees
        )
{
//------------------------------------------------------------------------------
//
// Header for Output
//
//------------------------------------------------------------------------------
   fprintf
    (
      stdout,
      "\n\n\n"
      "%s%s\n"
      "%s\n"
      "%s\n"
      "%s%s\n"
      "%s\n"
      "%s\n"
      "%s\n",
      "============================================",
      "============================================",
      "|",
      "| EARTH-CENTERED EARTH-FIXED (ECEF) RECTANGULAR COORDINATES",
      "| TO GEODETIC CONVERSIONS USING THIRD ORDER",
      " HALLEY'S ITERATIVE METHOD",
      "| ONLY ONE HALLEY's ITERATION IS USED TO ACHIEVE FULL",
      "| DOUBLE PRECISION ACCURACY.",
      "|"
    );
   fprintf
    (
      stdout,
      "%s%s\n"
      "%s\n"
      "%s%s%+12.4f%s\n"
      "%s\n"
      "%s%s\n",
      "|-------------------------------------------",
      "--------------------------------------------",
      "|",
      "| True Geocentric East ",
      "Longitude:-->",
      specifiedFixedTrueEastGeocentricLongitudeDegrees,
      " [degrees]",
      "|",
      "|===========================================",
      "============================================"
    );
   fprintf
    (
      stdout,
      "%s%s%s\n",
      "|                   ",
      "|                  ",
      "|    GEODETIC CONVERSION ERROR RESULTS   "
    );
   fprintf
    (
      stdout,
      "%s%s%s%s\n",
      "|  True             ",
      "|                  ",
      "|--------------------",
      "---------------------"
    );
   fprintf
    (
      stdout,
      "%s%s%s%s\n",
      "|  Geodetic         ",
      "|  True            ",
      "|  Delta             ",
      "|   Delta"
    );
   fprintf
    (
      stdout,
      "%s%s%s%s\n",
      "|  North            ",
      "|  Geodetic        ",
      "|  Geodetic          ",
      "|   Geodetic"
    );
   fprintf
    (
      stdout,
            "%s%s%s%s\n",
      "|  Latitude         ",
      "|  Altitude        ",
      "|  Latitude          ",
      "|   Altitude"
    );
   fprintf
    (
      stdout,
      "%s%s\n",
      "|-------------------+------------------",
      "+--------------------+--------------------"
    );
   fprintf
    (
      stdout,
      "%s%s%s%s\n",
      "|  [degrees]        ",
      "|  [meters]        ",
      "|  [microArcSeconds] ",
      "|   [nanoMeters]"
    );
   fprintf
    (
      stdout,
      "%s%s\n",
      "--------------------+------------------",
      "+--------------------+--------------------"
    );
//------------------------------------------------------------------------------
   return;
//------------------------------------------------------------------------------
}
//==============================================================================
