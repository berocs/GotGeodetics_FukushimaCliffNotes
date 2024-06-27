function                                                                     ...
generateConvertEcefToGeodeticUsageMessage(  )
%{------------------------------------------------------------------------------
   STDOUT = 1;
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   fprintf                                                                   ...
   (                                                                         ...
     STDOUT,                                                                 ...
     [                                                                       ...
       '\n\n\n'                                                              ...
       '%s%s\n'                                                              ...
       '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                            ...
       '%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                                        ...
       '%s%s\n'                                                              ...
       '\n\n\n'                                                              ...
     ],                                                                      ...
     '====================================================================', ...
     '===========',                                                          ...
     '|',                                                                    ...
     '|  USAGE:',                                                            ...
     '|',                                                                    ...
     '|    [                                                ...',            ...
     '|      ecefToGeodeticConversionStatusEnumeration,     ...',            ...
     '|      estimatedGeodeticNorthLatitudeRadians,         ...',            ...
     '|      estimatedGeocentricEastLongitudeRadians,       ...',            ...
     '|      estimatedGeodeticAltitudeMeters                ...',            ...
     '|    ] = convertEcefToGeodetic                        ...',            ...
     '|               (                                     ...',            ...
     '|                 earthEquatorialRadiusMeters,        ...',            ...
     '|                 earthEllipsoidalFlatteningFactor,   ...',            ...
     '|                 xEcefMeters,                        ...',            ...
     '|                 yEcefMeters,                        ...',            ...
     '|                 zEcefMeters                         ...',            ...
     '|               );',                                                   ...
     '|',                                                                    ...
     '====================================================================', ...
     '==========='                                                           ...
   );
%------------------------------------------------------------------------------- 
   return;
%}------------------------------------------------------------------------------
