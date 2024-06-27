//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include "conversionBetweenEcefAndGeodetic.h"

//------------------------------------------------------------------------------
void
generateConvertGeodeticToEcefUsageMessage(  )
{
//------------------------------------------------------------------------------
   fprintf
    (
      stdout,
      "\n\n\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n"              
      "\n\n\n",
      "====================================================================",
      "|",
      "|   USAGE:",
      "|",
      "|     const double   earthEquatorialRadiusMeters;",
      "|     const double   ellipsoidalEccentricitySquared;",
      "|     const double   geodeticNorthLatitudeRadians;",
      "|     const double   geocentricEastLongitudeRadians;",
      "|     const double   geodeticAltitudeMeters;",
      "|",
      "|           double & rXEcefMeters;",
      "|           double & rYEcefMeters;",
      "|           double & rZEcefMeters;",
      "|",
      "|     void",
      "|     convertGeodeticToEcef",
      "|            (",
      "|             //----------------",
      "|             // INPUT(s):",
      "|             //----------------",
      "|                earthEquatorialRadiusMeters,",
      "|                ellipsoidalEccentricitySquared,",
      "|                geodeticNorthLatitudeRadians,",
      "|                geocentricEastLongitudeRadians,",
      "|                geodeticAltitudeMeters,",
      "|             //----------------",
      "|             // OUTPUT(s):",
      "|             //----------------",
      "|                rXEcefMeters,",
      "|                rYEcefMeters,",
      "|                rZEcefMeters",
      "|            );",
      "|",
      "===================================================================="
    );

//------------------------------------------------------------------------------
   return;
//------------------------------------------------------------------------------
}
//==============================================================================

