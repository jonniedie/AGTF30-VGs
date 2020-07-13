% Initialize gains
VSV = initialize_gains();
VAFN = initialize_gains();


%% =========================================================================================
% Inputs
% ==========================================================================================
% N1 to N3/P13 schedules
n1 =  [  940,  2000];
n3 =  [18000, 21366];
p13 = [ 1.05, 1.257];

% Wf control limit enabling
MWS.Cntrl.Limit_En(:) = 1;

% % VSV PI gains
VSV.k_p = 0.002;
% VSV.k_i = 0.1;

% % VAFN PI gains (took this out of the model for now)
VAFN.k_p = 0.00000007;
% VAFN.k_i = 0.00000017;


%% =========================================================================================
% Setup
% ==========================================================================================
sim('AGTF30SysDyn.mdl');
data = out_Dyn.eng.Data.HPC_Data;

if ~exist('baseline')
    tempVSV = VSV;
    tempVAFN = VAFN;
    VSV = initialize_gains();
    VAFN = initialize_gains();
    sim('AGTF30SysDyn.mdl');
    baseline = out_Dyn.eng.Data.HPC_Data;
    VSV = tempVSV;
    VAFN = tempVAFN;
end


%% =========================================================================================
% Plotting
% ==========================================================================================
figure;

plot(baseline.Wcin.Data./baseline.s_C_Wc.Data, baseline.PR.Data./baseline.s_C_PR.Data, 'o');
hold on
plot(data.Wcin.Data./data.s_C_Wc.Data, data.PR.Data./data.s_C_PR.Data, 'o');
grid on

legend({'Baseline', 'Modified'}, 'location', 'southeast');

xlim([140 190]);
ylim([14 21]);

title({'Compressor Map: ',...
    ['VSV:  k_p = ', num2str(VSV.k_p), ',  k_i = ', num2str(VSV.k_i)],...
    ['VAFN:  k_p = ', num2str(VAFN.k_p), ',  k_i = ', num2str(VAFN.k_i)]});


%% =========================================================================================
% Extras
% ==========================================================================================
function sys = initialize_gains()
    sys.k_p = 0;
    sys.k_i = 0;
end