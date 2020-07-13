% Very Rough shifting for off nonminal VSV correction.

% Get scalar for Wc 
Wc3 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.WcArray, 1.0,1.05);
Wc2 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.WcArray, 1.0,0.95);
Wc1 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.WcArray, 1.0,1.0);

WcRatio = Wc2/Wc1; % True for off nominal VSVs near full power
WcRatio2 = Wc3/Wc1; % True for off nominal VSVs near full power

% Get scalar for PR
PR3 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.PRArray, 1.0,1.05);
PR2 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.PRArray, 1.0,0.95);
PR1 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.PRArray, 1.0,1.0);

PRRatio = (PR2-1)/(PR1-1); 
PRRatio2 = (PR3-1)/(PR1-1); 

% Assume scalar for Efficiency (slight loss)
EffRatio = 0.98;

% Create 3D map
WcMap = ones(13,11,3);
PRMap = ones(13,11,3);
EffMap = ones(13,11,3);

WcMap(:,:,2) = MWS.HPC.WcArray;
PRMap(:,:,2) = MWS.HPC.PRArray;
EffMap(:,:,2) = MWS.HPC.EffArray;

% -------------------------------------------
% Final maps for CompressorVG
WcMap(:,:,3) = MWS.HPC.WcArray * WcRatio*0.95;
PRMap(:,:,3) = (MWS.HPC.PRArray-1) * PRRatio + 1;
EffMap(:,:,3) = MWS.HPC.EffArray * EffRatio;
WcMap(:,:,1) = MWS.HPC.WcArray * WcRatio2*1.05;
PRMap(:,:,1) = (MWS.HPC.PRArray -1) * PRRatio2 + 1;
EffMap(:,:,1) = MWS.HPC.EffArray * EffRatio;
% aribitrary alpha value you can use for compressorVG
Alpha = [-1 0 1];
% Note: other values must be transfered over from previous compressor block
% this includes, bleed info, scalars NcVec and RVecs, etc.
PRSM=ones(13,3);
WcSM=ones(13,2);

PRSM(:,1) = PRMap(:,1,1); 
PRSM(:,2) = PRMap(:,1,2); 
PRSM(:,3) = PRMap(:,1,3); 

WcSM(:,1) = WcMap(:,1,1); 
WcSM(:,2) = WcMap(:,1,2); 
WcSM(:,3) = WcMap(:,1,3); 

MWS.HPC.WcMap = WcMap;
MWS.HPC.PRMap = PRMap;
MWS.HPC.EffMap = EffMap;

MWS.HPC.PRSM = PRSM;
MWS.HPC.WcSM = WcSM;
MWS.HPC.Alpha = Alpha;

plot(WcMap(:,:,1)', PRMap(:,:,1)', 'bo')
hold on
plot(WcSM(:,1)', PRSM(:,1)', 'b-')
plot(WcMap(:,:,2)', PRMap(:,:,2)', 'ro')
plot(WcSM(:,2)', PRSM(:,2)', 'r-')
plot(WcMap(:,:,3)', PRMap(:,:,3)', 'go')
plot(WcSM(:,3)', PRSM(:,3)', 'g-')




