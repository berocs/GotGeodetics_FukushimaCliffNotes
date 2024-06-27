//==============================================================================
//       1         2         3         4         5         6         7         8
//345678901234567890123456789012345678901234567890123456789012345678901234567890
//==============================================================================

#include "conversionBetweenEcefAndGeodetic.h"

//------------------------------------------------------------------------------
void
generateTestProgramPurposeMessage(  )
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
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n"
      "%s\n%s\n%s\n%s\n%s\n%s\n%s\n"                
      "\n\n\n",
      "====================================================================",
      "|",
      "| PURPOSE:",
      "|",
      "|    This program will test the conversion of Earth-Centered Earth-",
      "|    Fixed (ECEF) retangular coordinates to geodetic coordinates",
      "|    for a specified reference ellipsoid.",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  METHOD OF CONVERSION FOR EACH ECEF X, Y, Z RECTANGULAR",
      "|  COORDINATES TO GEODETIC COORDINATES:",
      "|",
      "|    [ 1 ] Uses the economic third-order Halley's method to",
      "|          approximate a solution for the general non-linear",
      "|          geodetic equation numerically.",
      "|",
      "|    [ 2 ] Uses only one iteration of the iterative Halley's",
      "|          method to achieve full double precision accuracy.",
      "|",
      "|    [ 3 ] Uses a technique to avoid division operations which",
      "|          significantly accelerates the backward transformation",
      "|          without degrading the precision.",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  STRATEGY FOR MEASURING CONVERION ACCURACY OF ONE SET OF",
      "|  ECEF COORDINATES CONVERTED TO GEODETIC COORDINATES:",
      "|",
      "|    [ 1 ]  Define true geodetic latitude and altitude",
      "|           values along the East geocentric longitude",
      "|           meridian at specified longitude [degrees].",
      "|",
      "|    [ 2 ]  Generate true rectangular values based on the",
      "|           true geodetic latitude, true geodetic altitude",
      "|           and true geocentric longitude' values.",
      "|",
      "|    [ 3 ]  Compute estimated geodetic values based on the",
      "|           true rectangular values",
      "|",
      "|    [ 4 ]  Report the differences between the defined true",
      "|           geodetic values and the estimated geodetic",
      "|           values.",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  COORDINATE CONVERSION TIMING:",
      "|",
      "|  COORDINATE CONVERSION TIMING MEASUREMENTS OCCUR OVER A TRIAL",
      "|",
      "|  A TRIAL OCCURS OVER A SPECIFIED TRUE GEOCENTRIC",
      "|  LONGITUDE (ie. ON A SPECIFIED GEOCENTRIC MEDIDIAN)",
      "|",
      "|  A TRIAL CONSISTS OF:",
      "|",
      "|    Performing the following 32 ECEF rectangular",
      "|    X, Y, Z coordinates to geodetic latitude and",
      "|    altitude conversions.",
      "|",
      "|      [ 1 ]  Converting ECEF rectangular X, Y, Z coordinates",
      "|             at each 15 degrees of true geodetic latitude",
      "|             along the specified true East longitude meridian",
      "|             from the equator to the north pole.",
      "|",
      "|      [ 2 ]  At each true geodetic latitude,",
      "|             perform seperate geodetic coordinate conversions",
      "|             at each of four specified true geodetic altitudes.",
      "|",
      "|    Report the sum of the execution times over each of",
      "|    the coordinate conversion function calls involved in",
      "|    the 32 ECEF rectangular coorindates conversions to",
      "|    geodetic coordinates.",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  AUTHOR(s):",
      "|",
      "|    [ 1 ]  Toshio Fukushima <Toshio.Fukushima@nao.ac.jp>",
      "|           National Astronomical Observatory of Japan (NAOJ)",
      "|           Address:  2-21-1, Ohsawa, Mitaka, Tokyo 181-8588, Japan",
      "|           Phone:    +81-422-34-3613",
      "|",
      "|-------------------------------------------------------------------",
      "|",
      "|  REFERENCE(s):",
      "|",
      "|    [ 1 ]  'Transformation from Cartesian to geodetic",
      "|            coordinates accelerated by Halley's method",
      "|           Toshio Fukushima,",
      "|           J.Geodesy (2006),",
      "|           Volume 79,",
      "|           Pages 689-693",
      "|",
      "|    [ 2 ]  'Fast transform from geocentric to geodetic coordinates'",
      "|           Toshio Fukushima,",
      "|           Journal Of Geodesy (1999),",
      "|           Volume 73,",
      "|           Pages 603–610",
      "|",
      "|    [ 3 ]  'Geometric Geodesy, Part A',",
      "|           'A set of lecture notes which are an introduction to",
      "|            ellipsoidal geometry related to geodesy.",
      "|           R. E. Deakin and M. N. Hunter,",
      "|           School of Mathematical and Geospatial Sciences,",
      "|           RMIT University,",
      "|           Melbourne, Australia,",
      "|           January 2013",
      "|           www.mygeodesy.id.au/documents/Geometric",
      "|               %20Geodesy%20A(2013).pdf",
      "|",
      "|    [ 4 ]  'Various parameterizations of 'latitude' equation -",
      "|            Cartesian to geodetic coordinates transformation',",
      "|            Marcin Ligas,",
      "|            Journal of Geodetic Science,",
      "|            Pages 87 - 94,",
      "|            2013",
      "|",
      "|    [ 5 ]  'In numerical analysis, Halley's method is a root-",
      "|            finding algorithm used for functions of one real",
      "|            variable with a continuous second derivative.",
      "|           'The rate of convergence of the iterative Halley's",
      "|            method is cubic.',",
      "|           'There exist multidimensional versions of Halley's",
      "|            method.",
      "|            wikipedia.org/wiki/Halley's_method",
      "|",
      "===================================================================="
    );

//------------------------------------------------------------------------------
   return;
//------------------------------------------------------------------------------
}
//==============================================================================

