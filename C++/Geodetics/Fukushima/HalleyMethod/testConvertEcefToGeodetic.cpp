//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include "conversionBetweenEcefAndGeodetic.h"

//------------------------------------------------------------------------------
int
main
 (
   //-------------------
   // INPUT(s):
   //-------------------
      const int    numberCommandLineArguments,
      const char *pVectorCommandLineArguments[ ]
   //-------------------
   // OUTPUT(s):
   //           NONE
   //-------------------
 )
//==============================================================================
//
//  MAIN PROGRAM:
//    testConvertEcefToGeodetic 
//
//------------------------------------------------------------------------------
//
//  PURPOSE:
//
//    To test the conversion of specified Earth Centered Earth Fixed (ECEF)
//    retangular coordinates to geodetic coordinates for a specified
//    reference ellipsoid.
//
//------------------------------------------------------------------------------
//
//  METHOD:
//
//    [ 1 ] Uses the economic third-order Halley's method to solve the
//          general non-linear fourth-order algebraic geodetic equation
//          numerically.
//
//    [ 2 ] Uses only  one iteration of the iterative Halley's method
//          to achieve near double precision accuracy.
//
//    [ 3 ] Uses a technique to avoid division operations which significantly
//          accelerates the backward transformation without degrading the
//          precision.
//
//------------------------------------------------------------------------------
//
//  AUTHOR(s):
//
//    [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
//           National Astronomical Observatory of Japan (NAOJ)
//           Address:  2-21-1, Ohsawa, Mitaka, Tokyo   181-8588,  Japan
//           Phone:    +81-422-34-3613
//
//------------------------------------------------------------------------------
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
//             R. E. Deakin and M. N. Hunter,
//             School of Mathematical and Geospatial Sciences,
//             RMIT University,
//             Melbourne, Australia,
//             January 2013
//             www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
//
//     [ 4 ]  'Various parameterizations of "latitude" equation -
//             Cartesian to geodetic coordinates transformation',
//             Marcin Ligas,
//             Journal of Geodetic Science,
//             Pages 87 - 94,
//             2013
//
//     [ 5 ]  "In numerical analysis, Halley's method is a root-finding
//             algorithm used for functions of one real variable with a
//             continuous second derivative.",
//            "The rate of convergence of the iterative Halley's method
//             is cubic.",
//            "There exist multidimensional versions of Halley's method.",
//            wikipedia.org/wiki/Halley's_method`
//
//==============================================================================
{
//------------------------------------------------------------------------------
   int     mainProgramReturnValue = 0;
//------------------------------------------------------------------------------
   const
   double  piRadians                      = 4.0 * atan( 1.0 );
   const
   double  radiansPerDegree               = piRadians / 180.0;
   const
   double  degreesPerRadian               = 180.0     / piRadians;
   const
   double  arcSecondsPerArcMinute         =  60.0;
   const
   double  arcMinutesPerDegree            =  60.0;
   const
   double  microArcSecondsPerSecond       =   1.0E6;
   const
   double  microArcSecondsPerDegree       = microArcSecondsPerSecond *
                                            arcSecondsPerArcMinute   *
                                            arcMinutesPerDegree;
   const
   double  microArcSecondsPerRadian       = degreesPerRadian         *
                                            microArcSecondsPerDegree;
   const
   double  nanoMetersPerMeter             = 1.0E9;
//------------------------------------------------------------------------------
//
// The parameters:
//   [ 1 ]  Earth equatorial radius [meters]
//   [ 2 ]  Inverse Earth ellipsoidal flattening factor
// are set to the GRS1980 System values.
//
//------------------------------------------------------------------------------
   const
   double  earthEquatorialRadiusMeters    = 6378137.0E0;
   const
   double  inverseEarthEllipsoidalFlatteningFactor
                                          =     298.257222101E0;
//------------------------------------------------------------------------------
   const
   double  earthEllipsoidalFlatteningFactor
                                          =
                                1.0E0 /
                                inverseEarthEllipsoidalFlatteningFactor;
   const
   double  earthEllipsoidalEccentricitySquared
                                          = (
                                              2.0E0 -
                                              earthEllipsoidalFlatteningFactor
                                            )
                                            *
                                              earthEllipsoidalFlatteningFactor;
//------------------------------------------------------------------------------
// Fixed the longitude at 45 degrees for test purposes.
//------------------------------------------------------------------------------
   const
   double  specifiedFixedTrueEastGeocentricLongitudeDegrees = 45.0;
//==============================================================================
//
// STRATEGY:
//
//   [ 1 ]  Define true geodetic latitude and altitude
//          values along the 45-degree East geocentric
//          longitude meridian.
//
//   [ 2 ]  Generate true rectangular values based on the
//          true geodetic latitude, true geodetic altitude
//          and constant geocentric longitude' values.
//
//   [ 3 ]  Compute estimated geodetic values based on the
//          true rectangular values
//
//   [ 4 ]  Report the differences between the defined true
//          geodetic values and the estimated geodetic
//          values.
//
//==============================================================================
   const
   double  specifiedFixedTrueEastGeocentricLongitudeRadians =
                        radiansPerDegree *
                        specifiedFixedTrueEastGeocentricLongitudeDegrees;
//------------------------------------------------------------------------------
//
// Generate a purpose message.
//
//------------------------------------------------------------------------------
   generateTestProgramPurposeMessage(  );
//------------------------------------------------------------------------------
//
// Generate Header for Output
//
//------------------------------------------------------------------------------
   generateTestProgramOutputHeader
           (
             specifiedFixedTrueEastGeocentricLongitudeDegrees
           );
//------------------------------------------------------------------------------
   const
   double  deltaLatitudeDegrees = 15.0;
   const
   int     numberLatitudeSteps  =  6;
   const
   int     numberAltitudeSteps  =  3;
//------------------------------------------------------------------------------
   const
   double  TEN_KILOMETERS_IN_METERS           =   10000.0;
   const
   double  ONE_THOUSAND_KILOMETERS_IN_METERS  = 1000000.0;
//------------------------------------------------------------------------------
   const
   double  minimumTrueGeodeticLatitudeDegrees =  0.000000001;
   const
   double  maximumTrueGeodeticLatitudeDegrees = 89.999999999;
//------------------------------------------------------------------------------
   double  maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs = 0.0;
   double  maximumGeodeticAltitudeAbsoluteErrorNanoMeters        = 0.0;
//------------------------------------------------------------------------------
//
// Loop over Geodetic Latitude values.
//
//------------------------------------------------------------------------------
   for(
        int latitudeIndex  = -1;
            latitudeIndex <=  numberLatitudeSteps;
            latitudeIndex  =  latitudeIndex + 1
      )
      {
       //-----------------------------------------------------------------------
          double  trueNorthGeodeticLatitudeDegrees = latitudeIndex *
                                                     deltaLatitudeDegrees;
       //-----------------------------------------------------------------------
          trueNorthGeodeticLatitudeDegrees   =
              fmin(
                    maximumTrueGeodeticLatitudeDegrees,
                    fmax(
                          trueNorthGeodeticLatitudeDegrees,
                          minimumTrueGeodeticLatitudeDegrees
                        )
                  );
       //-----------------------------------------------------------------------
          const
          double
           trueGeodeticNorthLatitudeRadians  = radiansPerDegree *
                                               trueNorthGeodeticLatitudeDegrees;
       //--------------- -------------------------------------------------------
       //
       // Loop over Geodetic Altitude values.
       //
       //-----------------------------------------------------------------------
          for(
               int altitudeIndex  =  0;
                   altitudeIndex <=  numberAltitudeSteps;
                   altitudeIndex  =  altitudeIndex + 1
             )
             {
              //----------------------------------------------------------------
                 double trueGeodeticAltitudeMeters = 0.0;
              //----------------------------------------------------------------
                 if( altitudeIndex == 0 )
                   {
                    //----------------------------------------------------------
                       trueGeodeticAltitudeMeters = -TEN_KILOMETERS_IN_METERS;
                    //----------------------------------------------------------
                   }
                 else
                   {
                    //----------------------------------------------------------
                       trueGeodeticAltitudeMeters =
                                           altitudeIndex *
                                           ONE_THOUSAND_KILOMETERS_IN_METERS;
                    //----------------------------------------------------------
                   };
              //----------------------------------------------------------------
              // Convert the true geodetic coordinates into Earth Centered
              // Earth Fixed (ECEF) noninertial coordinates.
              //----------------------------------------------------------------
                 double xTrueEcefMeters = NAN;
                 double yTrueEcefMeters = NAN;
                 double zTrueEcefMeters = NAN;
              //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
                 ( void )
                 convertGeodeticToEcef
                        (
                         //----------------
                         // INPUT(s):
                         //----------------
                            earthEquatorialRadiusMeters,
                            earthEllipsoidalEccentricitySquared,
                            trueGeodeticNorthLatitudeRadians,
                            specifiedFixedTrueEastGeocentricLongitudeRadians,
                            trueGeodeticAltitudeMeters,
                         //----------------
                         // OUTPUT(s):
                         //----------------
                            xTrueEcefMeters,
                            yTrueEcefMeters,
                            zTrueEcefMeters
                        );
              //----------------------------------------------------------------
              // Use Halley's third order iterative method
              // (applying only one iteration) to approximate the solution of
              // the fourth order nonlinear algebraic geodetic equations.
              //----------------------------------------------------------------
                 double estimatedGeodeticNorthLatitudeRadians   = 0.0;
                 double estimatedGeocentricEastLongitudeRadians = 0.0;
                 double estimatedGeodeticAltitudeMeters         = 0.0;
              //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
                 ECEF_TO_GEODETIC_CONVERSION_STATUS
                   functionReturnedStatus =
                   convertEcefToGeodetic
                          (
                            //-----------------
                            // INPUT(s):
                            //-----------------
                               earthEquatorialRadiusMeters,
                               earthEllipsoidalFlatteningFactor,
                               xTrueEcefMeters,
                               yTrueEcefMeters,
                               zTrueEcefMeters,
                            //-----------------
                            // OUTPUT(s):
                            //-----------------
                               estimatedGeodeticNorthLatitudeRadians,
                               estimatedGeocentricEastLongitudeRadians,
                               estimatedGeodeticAltitudeMeters
                          );
              //----------------------------------------------------------------
                 if( functionReturnedStatus == SUCCESSFUL_CONVERSION )
                   {
                    //----------------------------------------------------------
                    // Geocentric to Geodetic conversion was successful.
                    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                    //
                    // Compute the residuals (errors):
                    //
                    //----------------------------------------------------------
                       const
                        double
                        deltaGeodeticLatitudeRadians =
                                     trueGeodeticNorthLatitudeRadians -
                                     estimatedGeodeticNorthLatitudeRadians;
                        const
                         double
                         deltaGeodeticLatitudeMicroArcSec = 
                                      microArcSecondsPerRadian  *
                                      deltaGeodeticLatitudeRadians;
                    //- - - - - - - - - - - - - - - - - - - - - - - - - -
                        const
                         double
                         deltaGeodeticAltitudeMeters =
                                      trueGeodeticAltitudeMeters -
                                      estimatedGeodeticAltitudeMeters;
                        const
                         double
                         deltaGeodeticAltitudeNanoMeters  =
                                      nanoMetersPerMeter *
                                      deltaGeodeticAltitudeMeters;
                    //----------------------------------------------------------
                        maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs =
                        std::max
                        (
                          maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
                          abs( deltaGeodeticLatitudeMicroArcSec )
                        );
                    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        maximumGeodeticAltitudeAbsoluteErrorNanoMeters =
                        std::max
                        (
                          maximumGeodeticAltitudeAbsoluteErrorNanoMeters,
                          abs( deltaGeodeticAltitudeNanoMeters )
                        );
                    //----------------------------------------------------------
                    // Output results.
                    //----------------------------------------------------------
                       fprintf
                         (       
                           stdout,
                           "%+19.10f %+18.5f  %+19.10e  %+18.10e\n",
                           trueNorthGeodeticLatitudeDegrees,
                           trueGeodeticAltitudeMeters,
                           deltaGeodeticLatitudeMicroArcSec,
                           deltaGeodeticAltitudeNanoMeters
                         );
                    //----------------------------------------------------------
                   }
                 else
                   {
                    //----------------------------------------------------------
                    // Geocentric to Geodetic conversion has failed.
                    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                    // Generate an error message.
                    //----------------------------------------------------------
                       if(
                           functionReturnedStatus
                           ==
                           INVALID_ELLIPSOIDAL_FLATTENING
                         )
                         {
                          //----------------------------------------------------
                          // Encountered invalid Earth ellipsoidal
                          // flattening value.
                          //- - - - - - - - - - - - - - - - - - - - - - - - - -
                          // Generate an error message.
                          //----------------------------------------------------
                             fprintf
                              (
                                stdout,
                                "\n\n\n"
                                "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
                                "%s\n%s\n%s\n"
                                "%s%+20e\n"
                                "%s\n%s\n"
                                "\n\n\n",
                                "---------------------------------------------",
                                "|",
                                "| ERROR:",
                                "|",
                                "|   Encountered invalid Earth ellipsoidal",
                                "|   flattening value.",       
                                "|",
                                "|   The Earth ellipsoidal flattening values",
                                "|   should be in the interval:",
                                "|     [ 0.0, 1.0 ).",
                                "|",
                                "|   The Earth ellipsoidal flattening value",
                                "|   was:   ",
                                earthEllipsoidalFlatteningFactor,
                                "|",
                                "---------------------------------------------"
                              );
                          //----------------------------------------------------
                         }
                       else
                       if
                         (
                           functionReturnedStatus
                           ==
                           INVALID_EQUATORIAL_RADIUS
                         )
                         {
                          //----------------------------------------------------
                          // Encountered invalid Earth equatorial radius.
                          //- - - - - - - - - - - - - - - - - - - - - - - - - -
                          // Generate an error message.
                          //----------------------------------------------------
                             fprintf
                              (
                                stdout,
                                "\n\n\n"
                                "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
                                "%s\n%s\n"
                                "%s%+20e%s\n"
                                "%s\n%s\n"
                                "\n\n\n",
                                "---------------------------------------------",
                                "|",
                                "| ERROR:",
                                "|",
                                "|   Encountered invalid Earth",       
                                "|   equatorial radius value.",
                                "|",
                                "|   The Earth equatorial radius",
                                "|   value should be strictly positive.",
                                "|",
                                "|   The Earth equatorial radius value",
                                "|   was:   ",
                                earthEquatorialRadiusMeters,
                                " [meters]",                    
                                "|",
                                "---------------------------------------------"
                              );
                          //----------------------------------------------------
                         }
                       else
                         {
                          //----------------------------------------------------
                          // Encountered undetermined Geodetic
                          // conversion error.
                          //- - - - - - - - - - - - - - - - - - - - - - - - - -
                          // Generate an error message.
                          //----------------------------------------------------
                             fprintf
                              (
                                stdout,
                                "\n\n\n"
                                "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
                                "\n\n\n",
                                "---------------------------------------------",
                                "|",
                                "| ERROR:",
                                "|",
                                "|   Encountered undetermined Geodetic",
                                "|   conversion error.",
                                "|",
                                "---------------------------------------------"
                              );
                                //----------------------------------------------
                         };
                          //----------------------------------------------------
                   };
              //----------------------------------------------------------------
             };
       //-----------------------------------------------------------------------
      };
//------------------------------------------------------------------------------
// Finish the output report.
//------------------------------------------------------------------------------
   fprintf
    (
      stdout,
      "%s%s"
      "\n\n\n",
      "============================================",
      "============================================"
    );
//------------------------------------------------------------------------------
   fprintf
    (
      stdout,
        "\n\n\n"
        "%s%s\n"
        "%s\n%s\n%s\n%s\n"
        "%s%+14.6e%s\n"
        "%s\n%s\n"
        "%s%+14.6e%s\n"
        "%s\n"
        "%s%s\n"
        "\n\n\n",
      "============================================",
      "============================================",
      "|",
      "|  MAXIMUM ABSOLUTE ERRORS OVER ONE TRIAL:",
      "|",
      "|    Maximum geodetic north latitude absolute error",
      "|      is:-->",
       maximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
      " [microarcseconds]",
      "|",
      "|    Maximum geodetic altitude absolute error",
      "|      is:-->",
      maximumGeodeticAltitudeAbsoluteErrorNanoMeters,
      " [nanometers]",
      "|",
      "============================================",
      "============================================"
    );
//------------------------------------------------------------------------------
   return( mainProgramReturnValue );
//------------------------------------------------------------------------------
}
//==============================================================================
