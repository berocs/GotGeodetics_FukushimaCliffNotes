def                                                                            \
generateConvertGeodeticToEcefUsageMessage(  ):
#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#{------------------------------------------------------------------------------
   import os;
#-------------------------------------------------------------------------------
   print                                                                       \
    (
      "\n\n\n",
      "====================================================================",
      "|",
      "|   USAGE:",
      "|",
      "|     convertGeodeticToEcefReturnValue =           \\",
      "|     convertGeodeticToEcef                        \\",
      "|            (                                     \\",
      "|              earthEquatorialRadiusMeters,        \\",
      "|              ellipsoidalEccentricitySquared,     \\",
      "|              geodeticNorthLatitudeRadians,       \\",
      "|              geocentricEastLongitudeRadians,     \\",
      "|              geodeticAltitudeMeters              \\",
      "|            );",
      "|",
      "====================================================================",
      "\n\n\n",
      sep=os.linesep
    );
#-------------------------------------------------------------------------------
   return;
#}------------------------------------------------------------------------------

