//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include "conversionBetweenEcefAndGeodetic.h"

//------------------------------------------------------------------------------
void
generateConvertEcefToGeodeticUsageMessage(  )
{
//------------------------------------------------------------------------------
   fprintf
    (
      stdout,
      "\n\n\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n"
      "\n\n\n",
      "====================================================================",
      "|",
      "|   USAGE:",
      "|",
      "|     const double  earthEquatorialRadiusMeters;",
      "|     const double  earthEllipsoidalFlatteningFactor;",
      "|     const double  xEcefMeters;",
      "|     const double  yEcefMeters;",
      "|     const double  zEcefMeters;",
      "|           double &rEstimatedGeodeticNorthLatitudeRadians;",
      "|           double &rEstimatedGeocentricEastLongitudeRadians;",
      "|           double &rEstimatedGeodeticAltitudeMeters;",
      "|",
      "|     ECEF_TO_GEODETIC_CONVERSION_STATUS",             
      "|     ecefToGeodeticConversionStatusReturnValue =",
      "|     convertEcefToGeodetic",
      "|            (",
      "|              //-------------------",
      "|              // INPUT(s):",
      "|              //-------------------",
      "|                 earthEquatorialRadiusMeters,",
      "|                 earthEllipsoidalFlatteningFactor,",
      "|                 xEcefMeters,",
      "|                 yEcefMeters,",
      "|                 zEcefMeters,",
      "|              //-------------------",
      "|              // OUTPUT(s):",
      "|              //-------------------",
      "|                 rEstimatedGeodeticNorthLatitudeRadians,",
      "|                 rEstimatedGeocentricEastLongitudeRadians,",
      "|                 rEstimatedGeodeticAltitudeMeters",
      "|            );",
      "|",
      "===================================================================="
    );

//------------------------------------------------------------------------------
   return;
//------------------------------------------------------------------------------
}
//==============================================================================

