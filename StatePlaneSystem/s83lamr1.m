function [FI,LAM,CONV,KP] = s83lamr1(NORTH,EAST,CM,EO,NB,RAD,ER,RF,F,ESQ,E,SINFO,RB,K,KO,NO,G)

% function [FI,LAM,CONV,KP] = s83lamr1(NORTH,EAST,CM,EO,NB,RAD,ER,RF,F,ESQ,E,SINFO,RB,K,KO,NO,G)
% convert state plane to geodesic co-ordinates
% original BY E. CARLSON / subroutine
% 15.03.12 M.P.

% LAMBERT CONFORMAL CONIC PROJECTION, 2 STANDARD PARALLELS
% CONVERSION OF GRID COORDINATES TO GEODETIC COORDINATES

% *********** SYMBOLS AND DEFINITIONS *************************
%   LATITUDE POSITIVE NORTH, LONGITUDE POSITIVE WEST.  ALL
%            ANGLES ARE IN RADIAN MEASURE.
%   FI,LAM ARE LAT. AND LONG. RESPECTIVELY
%   NORTH,EAST ARE NORTHING AND EASTING COORDINATES RESPECTIVELY
%   CONV IS CONVERGENCE
%   KP IS POINT SCALE FACTOR
%   ER IS THE SEMI-MAJOR AXIS FOR GRS-80
%   ESQ IS THE SQUARE OF THE 1ST ECCENTRICITY
%   E IS THE 1ST ECCENTRICITY
%   CM IS THE CENTRAL MERIDIAN OF THE PROJECTION ZONE
%   EO IS THE FALSE EASTING VALUE AT THE CM
%   NB IS THE FALSE NORTHING FOR THE SOUTHERNMOST
%         PARALLEL OF THE PROJECTION ZONE
%   SINFO = sin(FO)=> WHERE FO IS THE CENTRAL PARALLEL
%   RB IS THE MAPPING RADIUS AT THE SOUTHERNMOST PARALLEL
%   K IS MAPPING RADIUS AT THE EQUATOR
% *************************************************************

      E=sqrt(ESQ);
      NPR=RB-NORTH+NB;
      EPR=EAST-EO;
      GAM=atan(EPR/NPR);
      LON=CM-(GAM/SINFO);
      RPT=sqrt(NPR*NPR+EPR*EPR);
      Q=log(K/RPT)/SINFO;
      TEMP=exp(Q+Q);
      SINE=(TEMP-1.00)/(TEMP+1.00);
      
% DO 10
      for I=1:3

      	F1=(log((1.00+SINE)/(1.00-SINE))-E*log((1.00+E*SINE)/(1.00-E*SINE)))/2.00-Q;
      	F2=1.00/(1.00-SINE*SINE)-ESQ/(1.00-ESQ*SINE*SINE);
      	SINE=SINE-F1/F2;
% 10   
      end
      LAT=asin(SINE);
      
% ***
      FI = LAT;
      LAM = LON;
      SINLAT=sin(FI);
      COSLAT=cos(FI);
      CONV=(CM-LAM)*SINFO;

      Q=(log((1+SINLAT)/(1-SINLAT))-E*log((1+E*SINLAT)/(1-E*SINLAT)))/2.0;
      RPT=K/exp(SINFO*Q);
      WP=sqrt(1.0-ESQ*SINLAT^2);
      KP=WP*SINFO*RPT/(ER*COSLAT);


