def                                                                            \
generateTestProgramOutputHeader                                                \
        (                                                                      \
          specifiedFixedTrueEastGeocentricLongitudeDegrees                     \
        ):
#-------------------------------------------------------------------------------
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#-------------------------------------------------------------------------------

#{------------------------------------------------------------------------------
   import os;
#-------------------------------------------------------------------------------
   string1 = "============================================";
   string2 = "|===========================================";
   string3 = string1 + string1;
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   string4 = "|-------------------------------------------";
   string5 = "--------------------------------------------";
   string6 = string4 + string5;
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   string7 = string2 + string1;
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   print( "\n\n\n" );
   print(  string3 );
   print( "|"      );
   print(
           "| EARTH-CENTERED EARTH-FIXED (ECEF) RECTANGULAR COORDINATES"
        );
   print(
           "| TO GEODETIC CONVERSIONS USING THIRD ORDER",
           end=""
        );
   print(
           " HALLEY'S ITERATIVE METHOD",
        );
   print(
           "| ONLY ONE HALLEY's ITERATION IS USED TO ACHIEVE FULL",
           "| DOUBLE PRECISION ACCURACY.",
           "|",
           string6,
           "|",
           sep=os.linesep
        );
   print(
           "| True Geocentric East Longitude:-->",
           end=""
        );
   print(
           "%+10.6f " % ( specifiedFixedTrueEastGeocentricLongitudeDegrees ),
           end=""
        );
   print(
           " [degrees]"
        );
   print(  "|"  );
   print(
           "|===========================================",
           "============================================",
           sep=""
        );
   print(
           "|                   "  +
           "|                  "   +
           "|    GEODETIC CONVERSION ERROR RESULTS",
           "|                   "  +
           "|                  "   +
           "|--------------------" +
           "---------------------",
           "|  True             "  +
           "|  True            "   +
           "|  Delta             " +
           "|   Delta",
           "|  Geodetic         "  +
           "|  Geodetic        "   +
           "|  Geodetic          " +
           "|   Geodetic",
           "|  Latitude         "  +
           "|  Altitude        "   +
           "|  Latitude          " +
           "|   Altitude",
           "|-------------------"  +
           "+------------------"   +
           "+--------------------" +
           "+--------------------",
           "|  [degrees]        "  +
           "|  [meters]        "   +
           "|  [microArcSeconds] " +
           "|   [nanoMeters]",
           "--------------------"  +
           "+------------------"   +
           "+--------------------" +
           "+--------------------",
           sep=os.linesep
        );
#-------------------------------------------------------------------------------
   return;
#}------------------------------------------------------------------------------
