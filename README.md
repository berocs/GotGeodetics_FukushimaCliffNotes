# GotGeodetics Fukushima CliffNotes
Notes to aid reading the reference papers of Dr. Toshio Fukushima for conversion of geocentric rectangular coordinates to geodetic coordinates.

Example implementations and performance test results of the 2006 Fukushima algorithm using each of C/C++, Fortran, Matlab, Python and Julia.

Performance Results For C / C++ Implementation:

    CPU:     "Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz“

      • 8.3 [nanoseconds] per geocentric rectangular to geodetic conversion
      • Maximum geodetic north latitude absolute error over all trials is:--> +1.044606e+00 [microarcseconds]
      • Maximum geodetic altitude absolute error over all trials is:--------> +2.793968e+00 [nanometers]

    CPU:     "Intel(R) Xeon(R) W-2135 CPU @ 3.70GHz“

      • 0.56 [nanoseconds] per geocentric rectangular to geodetic conversion
      • Maximum geodetic north latitude absolute error over all trials is:--> +1.044606e+00 [microarcseconds]
      • Maximum geodetic altitude absolute error over all trials is:--------> +2.793968e+00 [nanometers]

