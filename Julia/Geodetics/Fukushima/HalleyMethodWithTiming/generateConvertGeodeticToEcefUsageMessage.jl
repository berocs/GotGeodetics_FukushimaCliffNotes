function
generateConvertGeodeticToEcefUsageMessage(  )
#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#{------------------------------------------------------------------------------
   formatString =
   string(
           "\n\n\n",
           "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
           "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
           "\n\n\n",
         );
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   printFormatted(
      stdout,
      formatString,
      "====================================================================",
      "|",
      "|   USAGE:",
      "|",
      "|     convertGeodeticToEcefReturnValue =",
      "|     convertGeodeticToEcef",
      "|            (",
      "|                earthEquatorialRadiusMeters,",
      "|                ellipsoidalEccentricitySquared,",
      "|                geodeticNorthLatitudeRadians,",
      "|                geocentricEastLongitudeRadians,",
      "|                geodeticAltitudeMeters,",
      "|            );",
      "|",
      "|     xEcefMeters = convertGeodeticToEcefReturnValue[ 1 ];",
      "|     yEcefMeters = convertGeodeticToEcefReturnValue[ 2 ];",
      "|     zEcefMeters = convertGeodeticToEcefReturnValue[ 3 ];",
      "|",
      "===================================================================="
    );
#-------------------------------------------------------------------------------
   return;
#-------------------------------------------------------------------------------
   end;
#}------------------------------------------------------------------------------

