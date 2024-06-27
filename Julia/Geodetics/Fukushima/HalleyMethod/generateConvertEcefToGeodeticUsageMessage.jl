function
generateConvertEcefToGeodeticUsageMessage(  )
#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#{------------------------------------------------------------------------------
   formatString =
   string(
           "\n\n\n",
           "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
           "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
           "%s\n%s\n%s\n%s\n",
           "\n\n\n"
         );
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   printFormatted(
      stdout,
      formatString,
      "====================================================================",
      "|",
      "|   USAGE:",
      "|",
      "|     convertEcefToGeodeticReturnValue =",
      "|     convertEcefToGeodetic",
      "|            (",
      "|                earthEquatorialRadiusMeters,",
      "|                earthEllipsoidalFlatteningFactor,",
      "|                xEcefMeters,",
      "|                yEcefMeters,",
      "|                zEcefMeters,",
      "|            );",
      "|",
      "|     conversionStatus               =",
      "|                          convertEcefToGeodeticReturnValue[ 1 ];",
      "|     geodeticNorthLatitudeRadians   =",
      "|                          convertEcefToGeodeticReturnValue[ 2 ];",
      "|     geocentricEastLongitudeRadians =",
      "|                          convertEcefToGeodeticReturnValue[ 3 ];",
      "|     geodeticAltitudeMeters         =",
      "|                          convertEcefToGeodeticReturnValue[ 4 ];",
      "|",
      "===================================================================="
    );
#-------------------------------------------------------------------------------
   return;
#-------------------------------------------------------------------------------
   end;
#}------------------------------------------------------------------------------

