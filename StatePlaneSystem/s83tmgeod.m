function [FI,LAM,CONV,KP] = s83tmgeod(NORTH,EAST,SF,OR,CM,FE,FN,RAD,ER,RF,F,ESQ,EPS,R,V0,V2,V4,V6,SO)

% function [FI,LAM,CONV,KP] = s83tmgeod(NORTH,EAST,SF,OR,CM,FE,FN,RAD,ER,RF,F,ESQ,EPS,R,V0,V2,V4,V6,SO)
% convert geodesic to state plane co-ordinates
% original BY E. CARLSON / subroutine
% 15.03.12 M.P.
% edited by benjamingetraer@gmail.com 8/26/2021
%   changed all operations to element-wise to allow batch conversions.

% TRANSVERSE MERCATOR PROJECTION
% CONVERSION OF GRID COORDS TO GEODETIC COORDS

% ************* SYMBOLS AND DEFINITIONS *******************************
%   LATITUDE POSITIVE NORTH, LONGITUDE POSITIVE WEST.  ALL
%            ANGLES ARE IN RADIAN MEASURE.
%   LAT,LON ARE LAT. AND LONG. RESPECTIVELY
%   N,E ARE NORTHING AND EASTING COORDINATES RESPECTIVELY
%   K IS POINT SCALE FACTOR
%   ER IS THE SEMI-MAJOR AXIS FOR GRS-80
%   ESQ IS THE SQUARE OF THE 1ST ECCENTRICITY
%   E IS THE 1ST ECCENTRICITY
%   CM IS THE CENTRAL MERIDIAN OF THE PROJECTION ZONE
%   FE IS THE FALSE EASTING VALUE AT THE CM
%   CONV IS CONVERGENCE
%   EPS IS THE SQUARE OF THE 2ND ECCENTRICITY
%   SF IS THE SCALE FACTOR AT THE CM
%   SO IS THE MERIDIANAL DISTANCE (TIMES THE SF) FROM THE
%         EQUATOR TO SOUTHERNMOST PARALLEL OF LAT. FOR THE ZONE
%   R IS THE RADIUS OF THE RECTIFYING SPHERE
%   U0,U2,U4,U6,V0,V2,V4,V6 ARE PRECOMPUTED CONSTANTS FOR
%     DETERMINATION OF MERIDIANAL DIST. FROM LATITUDE
%   
%   THE FORMULA USED IN THIS SUBROUTINE GIVES GEODETIC ACCURACY
%   WITHIN ZONES OF 7 DEGREES IN EAST-WEST EXTENT.  WITHIN STATE
%   TRANSVERSE MERCATOR PROJECTION ZONES, SEVERAL MINOR TERMS OF
%   THE EQUATIONS MAY BE OMMITTED (SEE A SEPARATE NGS PUBLICATION).
%   IF PROGRAMMED IN FULL, THE SUBROUTINE CAN BE USED FOR
%   COMPUTATIONS IN SURVEYS EXTENDING OVER TWO ZONES.
% **********************************************************************

      N = NORTH;
      E = EAST;
      OM=(N-FN+SO)./(R.*SF);
      COSOM=cos(OM);
      FOOT=OM+sin(OM).*COSOM.*(V0+V2.*COSOM.*COSOM+V4.*COSOM.^4+V6.*COSOM.^6);
      SINF=sin(FOOT);
      COSF=cos(FOOT);
      TN=SINF./COSF;
      TS=TN.*TN;
      ETS=EPS.*COSF.*COSF;
      RN=ER.*SF./sqrt(1.00-ESQ.*SINF.*SINF);
      Q=(E-FE)./RN;
      QS=Q.*Q;
      B2=-TN.*(1.00+ETS)./2.00;
      B4=-(5.00+3.00.*TS+ETS.*(1.00-9.00.*TS)-4.00.*ETS.*ETS)/12.00;
      B6=(61.00+45.00.*TS.*(2.00+TS)+ETS.*(46.00-252.00.*TS-60.00.*TS.*TS))./360.00;
      B1=1.00;
      B3=-(1.00+TS+TS+ETS)./6.00;
      B5=(5.00+TS.*(28.00+24.00.*TS)+ETS.*(6.00+8.00.*TS))./120.00;
      B7=-(61.00+662.00.*TS+1320.00.*TS.*TS+720.00.*TS.^3)./5040.00;
      LAT=FOOT+B2.*QS.*(1.00+QS.*(B4+B6.*QS));
      L=B1.*Q.*(1.00+QS.*(B3+QS.*(B5+B7.*QS)));
      LON=-L./COSF+CM;
      
% *** COMPUTE CONVERENCE AND SCALE FACTOR
      FI=LAT;
      LAM = LON;
      SINFI=sin(FI);
      COSFI=cos(FI);
      L1=(LAM-CM).*COSFI;
      LS=L1.*L1;

% *** CONVERGENCE
      C1=-TN;
      C3=(1.0+3.0.*ETS+2.0.*ETS.^2)./3.0;
      C5=(2.0-TS)./15.0;
      CONV=C1.*L1.*(1.0+LS.*(C3+C5.*LS));

% *** POINT SCALE FACTOR
      F2=(1.0+ETS)./2.0;
      F4=(5.0-4.0.*TS+ETS.*( 9.0-24.0.*TS))./12.0;
      KP=SF.*(1.0+F2.*LS.*(1.0+F4.*LS));

