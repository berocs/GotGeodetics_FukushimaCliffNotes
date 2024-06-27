//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include <algorithm>
#include <chrono>
#include <cmath>
#include <iostream>
#include <vector>

#include "conversionBetweenEcefAndGeodetic.h"
//------------------------------------------------------------------------------
   using namespace std;
   using namespace std::chrono;

//------------------------------------------------------------------------------
void
executeOneTrialConvertEcefToGeodetic
       (
         //-------------------
         // INPUT(s):
         //-------------------
            const
            double   specifiedFixedTrueGeocentricEastLongitudeDegrees,
         //-------------------
         // OUTPUT(s):
         //-------------------
            double   &rExecutionTimeOfTrialFunctionCallsMicroSeconds,
            double   &rMaximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
            double   &rMaximumGeodeticAltitudeAbsoluteErrorNanoMeters
       )
//==============================================================================
//|
//| FUNCTION:
//|
//|   executeOneTrialConvertEcefToGeodetic
//|
//|-----------------------------------------------------------------------------
//|
//| PURPOSE:
//|
//|   To perform one trial of converting Earth-Center Earth-Fixed (ECEF)
//|   retangular coordinates to geodetic coordinates for a specified
//|   reference ellipsoid.
//|
//|-----------------------------------------------------------------------------
//|
//| INPUT(s):
//|
//|   specifiedFixedTrueGeocentricEastLongitudeDegrees
//|     The specified true geocentric East longitude to be used for
//|     the current trial.
//|     UNIT(s):  [degrees]
//|
//|-----------------------------------------------------------------------------
//|
//| OUTPUT(s):
//|
//|   rExecutionTimeOfTrialFunctionCallsMicroSeconds
//|     A reference to a variable which will contain the sum of the
//|     execution times of each of the 'convertEcefToGeodetic'
//|     function calls in the current timing trial.
//|     UNIT(s):  [microseconds]
//|
//|   rMaximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs
//|     A reference to a variable which will contain the maximum
//|     geodetic north latitude absolute error over all
//|     'convertEcefToGeodetic' function calls in the current
//|     timing trial.
//|     UNIT(s):  [microarcseconds]
//|
//|   rMaximumGeodeticAltitudeAbsoluteErrorNanoMeters
//|     A reference to a variable which will contain the maximum
//|     geodetic altitude absolute error over all
//|     'convertEcefToGeodetic' function calls in the current
//|     timing trial.
//|     UNIT(s):  [nanometers]
//|
//|-----------------------------------------------------------------------------
//|
//| A TRIAL CONSISTS OF:
//|
//|   [ 1 ]  Performing the following 32 conversions.
//|
//|   [ 2 ]  Converting ECEF rectangular coordinates at each 15
//|          degrees of geodetic latitude along the specified
//|          geocentric longitude meridian from the equator
//|          to the north pole.
//|
//|   [ 3 ]  At each latitude, perform the conversion at four
//|          different geodetic altitudes.
//|
//|-----------------------------------------------------------------------------
//|
//|  METHOD OF EACH ECEF TO GEODETIC CONVERSION:
//|
//|   [ 1 ]  Uses the economic third-order Halley's method to
//|          approximate a solution for the general non-linear
//|          geodetic equation numerically.
//|
//|   [ 2 ]  Uses only one iteration of the iterative Halley's
//|          method to achieve near double precision accuracy.
//|
//|   [ 3 ]  Uses a technique to avoid division operations which
//|          significantly accelerates the backward transformation
//|          without degrading the precision.
//|
//|   [ 4 ]  Report the differences between the defined true
//|          geodetic values and the estimated geodetic
//|          values.
//|
//|-----------------------------------------------------------------------------
//|
//|  AUTHOR(s):
//|
//|   [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>
//|          National Astronomical Observatory of Japan (NAOJ)
//|          Address:  2-21-1, Ohsawa, Mitaka, Tokyo 181-8588, Japan
//|          Phone:    +81-422-34-3613
//|
//|-----------------------------------------------------------------------------
//|
//|  REFERENCE(s):
//|
//|   [ 1 ]  "Transformation from Cartesian to geodetic
//|           coordinates accelerated by Halley''s method",
//|          Toshio Fukushima,
//|          Journal Of Geodesy (2006),
//|          Volume 79,
//|          Pages 689-693
//|
//|   [ 2 ]  "Fast transform from geocentric to geodetic coordinates",
//|          Toshio Fukushima,
//|          Journal Of Geodesy (1999),
//|          Volume 73,
//|          Pages 603–610
//|
//|   [ 3 ]  "Geometric Geodesy, Part A",
//|          "A set of lecture notes which are an introduction to
//|           ellipsoidal geometry related to geodesy.",
//|           R. E. Deakin and M. N. Hunter,
//|           School of Mathematical and Geospatial Sciences,
//|           RMIT University,
//|           Melbourne, Australia,
//|           January 2013
//|           www.mygeodesy.id.au/documents/Geometric%20Geodesy%20A(2013).pdf
//|
//|   [ 4 ]  'Various parameterizations of "latitude" equation -
//|           Cartesian to geodetic coordinates transformation',
//|           Marcin Ligas,
//|           Journal of Geodetic Science,
//|           Pages 87 - 94,
//|           2013
//|
//|   [ 5 ]  "In numerical analysis, Halley's method is a root-finding
//|           algorithm used for functions of one real variable with a
//|           continuous second derivative.",
//|          "The rate of convergence of the iterative Halley's method
//|           is cubic.",
//|          "There exist multidimensional versions of Halley's method.",
//|          wikipedia.org/wiki/Halley's_method`
//|
//==============================================================================
{
 //-----------------------------------------------------------------------------
    rExecutionTimeOfTrialFunctionCallsMicroSeconds = NAN;
 //-----------------------------------------------------------------------------
    const
    double
     piRadians                     = 4.0 * atan( 1.0 );
    const
    double
     radiansPerDegree              = piRadians / 180.0;
    const
    double
     degreesPerRadian              = 180.0     / piRadians;
    const
    double
     secondsPerMinute              =  60.0;
    const
    double
     minutesPerDegree              =  60.0;
    const
    double
     microArcSecondsPerSecond      =   1.0E6;
    const
    double
     microArcSecondsPerDegree      = microArcSecondsPerSecond *
                                     secondsPerMinute         *
                                     minutesPerDegree;
    const
    double
     microArcSecondsPerRadian      = degreesPerRadian         *
                                     microArcSecondsPerDegree;
    const
    double
     nanoMetersPerMeter            = 1.0E9;
    const
    double
     microSecondsPerSecond         = 1.0E6;
 //-----------------------------------------------------------------------------
 //
 // GRS1980 System
 //
 //-----------------------------------------------------------------------------
    const
    double
     earthEquatorialRadiusMeters             = 6378137.0E0;
    const
    double
     inverseEarthEllipsoidalFlatteningFactor =     298.257222101E0;
 //-----------------------------------------------------------------------------
    const
    double
     earthEllipsoidalFlatteningFactor        =
                         1.0E0 / inverseEarthEllipsoidalFlatteningFactor;
    const
    double
     earthEllipsoidalEccentricitySquared =
                         ( 2.0E0 - earthEllipsoidalFlatteningFactor )
                         *
                         earthEllipsoidalFlatteningFactor;
 //-----------------------------------------------------------------------------
    const
    double
     specifiedFixedTrueGeocentricEastLongitudeRadians =
                         radiansPerDegree *
                         specifiedFixedTrueGeocentricEastLongitudeDegrees;
 //-----------------------------------------------------------------------------
 //
 // Generate header for output.
 //
 //-----------------------------------------------------------------------------
    generateTestProgramOutputHeader
            (
              specifiedFixedTrueGeocentricEastLongitudeDegrees
            );
 //-----------------------------------------------------------------------------
    const
    double
     deltaLatitudeDegrees = 15.0;
    const
    int
     minimumLatitudeIndex = -1;
    const
    int
     maximumLatitudeIndex =  6;
    const
    int
     minimumAltitudeIndex =  0;
    const
    int
     maximumAltitudeIndex =  3;
 //-----------------------------------------------------------------------------
    const
    double
     TEN_KILOMETER_IN_METERS            =   10000.0;
    const
    double
     ONE_THOUSAND_KILOMETERS_IN_METERS  = 1000000.0;
 //-----------------------------------------------------------------------------
    const
    double
     minimumTrueGeodeticLatitudeDegrees =  0.000000001E0;
    const
    double
     maximumTrueGeodeticLatitudeDegrees = 89.999999999E0;
 //-----------------------------------------------------------------------------
     double
     totalTrialTimeMicroSeconds = 0.0;
 //-----------------------------------------------------------------------------
    rMaximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs = 0.0;
    rMaximumGeodeticAltitudeAbsoluteErrorNanoMeters        = 0.0;
 //-----------------------------------------------------------------------------
 // Loop over Geodetic Latitude values.
 //-----------------------------------------------------------------------------
    for(
        int latitudeIndex  = minimumLatitudeIndex;
            latitudeIndex <= maximumLatitudeIndex;
            latitudeIndex  = latitudeIndex + 1
      )
      {
       //-----------------------------------------------------------------------
          double
           trueGeodeticNorthLatitudeDegrees = latitudeIndex *
                                              deltaLatitudeDegrees;
       //-----------------------------------------------------------------------
       // Include Near-Equator/Polar Cases 
       //-----------------------------------------------------------------------
          trueGeodeticNorthLatitudeDegrees =
                      min(
                           maximumTrueGeodeticLatitudeDegrees,
                           max(
                                trueGeodeticNorthLatitudeDegrees,
                                minimumTrueGeodeticLatitudeDegrees
                              )
                            );
       //-----------------------------------------------------------------------
          const
          double
           trueGeodeticNorthLatitudeRadians = radiansPerDegree *
                                              trueGeodeticNorthLatitudeDegrees;
       //-----------------------------------------------------------------------
       // Loop over Geodetic Altitude values.
       //-----------------------------------------------------------------------
          for(
              int altitudeIndex  = minimumAltitudeIndex;
                  altitudeIndex <= maximumAltitudeIndex;
                  altitudeIndex  = altitudeIndex + 1
            )
            {
             //-----------------------------------------------------------------
                double
                 trueGeodeticAltitudeMeters = 0.0;
             //-----------------------------------------------------------------
                if( altitudeIndex == minimumAltitudeIndex )
                  {
                   //-----------------------------------------------------------
                   // At minimum altitude index.
                   //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                   // Set the current true geodetic altitude to a minimum value.
                   //-----------------------------------------------------------
                      trueGeodeticAltitudeMeters = -10000.0E0;
                   //-----------------------------------------------------------
                  }
                else
                  {
                   //-----------------------------------------------------------
                   // Not at minimum altitude index.
                   //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                   // Set the current true geodetic altitude to indexed value.
                   //-----------------------------------------------------------
                      trueGeodeticAltitudeMeters = altitudeIndex * 1000000.0E0;
                   //-----------------------------------------------------------
                  };
             //-----------------------------------------------------------------
             // Convert the true geodetic coordinates into Earth Centered Earth
             // Fixed (ECEF) noninertial coordinates.
             //-----------------------------------------------------------------
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
                            specifiedFixedTrueGeocentricEastLongitudeRadians,
                            trueGeodeticAltitudeMeters,
                         //----------------
                         // OUTPUT(s):
                         //----------------
                            xTrueEcefMeters,
                            yTrueEcefMeters,
                            zTrueEcefMeters
                        );
              //----------------------------------------------------------------
              // Get starting timepoint.
              //----------------------------------------------------------------
                 auto timingStart = high_resolution_clock::now();
             //-----------------------------------------------------------------
             // Use Halley's third order iterative method
             // (applying only one iteration) to approximate the solution of
             // the fourth order nonlinear algebraic geodetic equations.
             //-----------------------------------------------------------------
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
              // Get stopping timepoint.
              //----------------------------------------------------------------
                 auto timingStop = high_resolution_clock::now();
              //----------------------------------------------------------------
              // Get current duration.
              //----------------------------------------------------------------
                 auto currentTrialTimeMicroSeconds =
                                        duration_cast
                                        <microseconds>
                                              ( timingStop - timingStart );
              //----------------------------------------------------------------
                 totalTrialTimeMicroSeconds =
                      totalTrialTimeMicroSeconds +
                      currentTrialTimeMicroSeconds.count( );
              //----------------------------------------------------------------
                 if( functionReturnedStatus == SUCCESSFUL_CONVERSION )
                   {
                    //----------------------------------------------------------
                    // Geocentric to Geodetic conversion was successful.
                    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                    //
                    // Compute the residuals:
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
                        rMaximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs =
                        std::max
                        (
                         rMaximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
                         abs( deltaGeodeticLatitudeMicroArcSec )
                        );
                    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        rMaximumGeodeticAltitudeAbsoluteErrorNanoMeters =
                        std::max
                        (
                         rMaximumGeodeticAltitudeAbsoluteErrorNanoMeters,
                         abs( deltaGeodeticAltitudeNanoMeters )
                        );
                    //----------------------------------------------------------
                    // Output results.
                    //----------------------------------------------------------
                       fprintf
                         (       
                           stdout,
                           "%+19.10f %+18.5f  %+19.10e  %+18.10e\n",
                           trueGeodeticNorthLatitudeDegrees,
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
                          // Encountered invalid ellipsoidal
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
                          //----------------------------------------------------
                         };
                    //----------------------------------------------------------
                   };
              //----------------------------------------------------------------
              // End of altitude loop.
              //----------------------------------------------------------------
            };
       //-----------------------------------------------------------------------
       // End of latitude loop.
       //-----------------------------------------------------------------------
      };
 //-----------------------------------------------------------------------------
 // Finish the output report.
 //-----------------------------------------------------------------------------
    fprintf
     (
       stdout,
       "%s%s\n\n\n",
       "============================================",
       "============================================"
     );
 //-----------------------------------------------------------------------------
    rExecutionTimeOfTrialFunctionCallsMicroSeconds =
                        totalTrialTimeMicroSeconds;
 //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fprintf
     (
       stdout,
       "\n\n\n"              
       "%s%s\n"              
       "%s\n%s\n%s\n%s\n"    
       "%s%+14.6e%s\n"       
       "%s\n"                
       "%s%s\n"              
       "\n\n\n",
       "==================================================================",
       "======================",
       "|",
       "| TRIAL TIMING RESULTS:",
       "|",
       "|   Cumulative execution time over all",
       "|     'convertEcefToGeodetic' function calls in trial:-->",
       rExecutionTimeOfTrialFunctionCallsMicroSeconds,
       " [microseconds]",
       "|",
       "==================================================================",
       "======================"
     );
 //-----------------------------------------------------------------------------
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
       rMaximumGeodeticNorthLatitudeAbsoluteErrorMicroArcSecs,
       " [microarcseconds]",
       "|",
       "|    Maximum geodetic altitude absolute error",
       "|      is:-->",
       rMaximumGeodeticAltitudeAbsoluteErrorNanoMeters,
       " [nanometers]",
       "|",
       "============================================",
       "============================================"
     );
 //-----------------------------------------------------------------------------
    return;
 //-----------------------------------------------------------------------------
}
//==============================================================================








