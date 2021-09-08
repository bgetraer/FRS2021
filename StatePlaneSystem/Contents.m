% StatePlaneSystem - State Plane Coordinate System conversion toolbox
% Copyright 2016, Markus Penzkofer (Retrieved August 25, 2021)
% Original release avialable for free online at MATLAB Central File Exchange:
%   https://www.mathworks.com/matlabcentral/fileexchange/57991-state-plane-system-usa)
% 
% Minor edits made by benjamingetraer@gmail.com, Aug 2021:
%   Contents.m      - (this document) written 8/26/2021
%   SPCS_zones.m    - appendix of State Plane Coordinate System zones
%   StatePlaneToLatLong.m   - removed extraneous renaming of output variables and printed output
%   LatLongToStatePlane.m   - removed extraneous renaming of output variables and printed output
%   s83tmgeod.m     - changed all operations to element-wise to allow batch conversions
%   s83tmgrid.m     - changed all operations to element-wise to allow batch conversions
%   s83tblspc.m     - commented out printed output
%   
%
% Supports transformation between State Plane Coordinate System (SPCS) and 
% lat/lon coordinates. State Plane coordinates are expected and returned in
% meters. 
%
% Each Zone of the SPCS has an associated identification code given
% by the National Geodetic Survey (NGS), referred to in this software as
% the "ICODE" and known elsewhere as the Federal Information Processing
% Standard (FIPS) zone or code. For a table of SPCS zones and codes, see:
%   SPCS_zones.m    - appendix of State Plane Coordinate System zones
%
% Zones are projected in either Lambert conformal conic, Transverse
% Mercator, or Hotine Oblique Mercator. 
%
%
% Toolbox contents
%   Contents.m  - this file
%   SPCS_zones.m    - appendix of State Plane Coordinate System zones
%   license.txt - original licensing information
%
% User-callable functions
%   LatLongToStatePlane.m   - transforms Lat/Lon to State Plane coordinates
%   StatePlaneToLatLong.m   - transforms State Plane coordinates to Lat/Lon
%
% Internal functions (not meant to be user-callable)
%     s83coshinline.m   - 
%     s83drgppc.m   - 
%     s83drpcgp.m   - 
%     s83gppc83.m   - 
%     s83lamd1.m   - 
%     s83lamr1.m   - 
%     s83lconst.m   - 
%     s83oconst.m   - 
%     s83pcgp83.m   - 
%     s83qinline.m   - 
%     s83qqinline.m   - 
%     s83skewd.m   - 
%     s83skewr.m   - 
%     s83tblspc.m   - 
%     s83tconpc.m   - 
%     s83tconst.m   - 
%     s83tinline.m   - 
%     s83tmgeod.m   - 
%     s83tmgrid.m   - 
%
% * end of contents * 