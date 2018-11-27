height = 130;
width = 130;
thickness = 1.27;
midWidth = 80  ;
%pos
co_eff_pos_mom = 83;
%neg
co_eff_neg_mom = 95;

force_coeff_pos = 0.349;
force_coeff_neg = .5;

%pos moment
ya = 99.292;
Ia = 1214139.838;

%neg moment
Ib = 1865510.142;
yb = 66.27;


ybarA = (height+thickness*2)-ya;
ybarB = (height+thickness*2)-yb;
         
crushA = comTop( ybarA,Ia,co_eff_pos_mom);
crushB = comTop( yb,Ib,co_eff_neg_mom);

tensA = tensBot( ya,Ia,co_eff_pos_mom);
tensB = tensBot( ybarB,Ib,co_eff_neg_mom);

boardA = matSheer((thickness*2),Ia,(2*thickness*ya*.5*ya),force_coeff_pos);
glueA = glueSheer(2*10 + 2*thickness,Ia,2*thickness*width*(height+thickness-ya),force_coeff_pos);

%boardB = matSheer((thickness*2),Ib,(2*thickness*ya*.5*ya),co_eff_pos_mom);
glueB = glueSheer(2*10 + 2*thickness,Ib,thickness*width*(height-thickness-yb),force_coeff_neg);
stressRatioA = (co_eff_pos_mom*ybarA)/Ia;
stressRatioB = (co_eff_neg_mom*yb)/Ib;


restraintA = plateRest(2*thickness,midWidth,stressRatioA);
freeA = plateOneEdge(2*thickness,(width-midWidth)/2,stressRatioA);

restraintB = plateRest(thickness,midWidth,stressRatioB);
freeB = plateOneEdge(thickness,(width-midWidth)/2,stressRatioB);
dist = 525;
psbVal = plateSheerBuckling(thickness, height, dist, stressRatioA);
forces = [["Compression A";crushA],["Compression B";crushB],["Tension A";tensA],["Tension A";tensB],["Sheer in board(using A)";boardA],["Sheer in board(using B)";-1],["Sheer in glue(using A)";glueA],["Sheer in glue(using B)";glueB],["Restrained Edge Plate Buckling (in A)";restraintA],["Restrained Edge Plate Buckling (in B)";restraintB],["Free edge Plate Buckling (in A)";freeA],["Free edge Plate Buckling (in B)";freeB],["Plate Sheer Buckling";psbVal]];

%Alan Test Stuff
%crushA = comTop(23.63,580.6E3,125);
%tensA = tensBot(78.87,580.6E3,125)
%matFail = matSheer(2.5,0,580.6E3,7776,1/2);

%Flexural Failure
function crushing = comTop(y,I,coeff)
COMP_STRENGTH=6;
crushing = (I*COMP_STRENGTH)/(coeff * y);
end

function tension = tensBot(y,I,coeff)
TENS_STRENGTH= 30;
tension = (I*TENS_STRENGTH)/(coeff * y);
end

%Sheer Failure
function boardSheer = matSheer(b,I,Q, coeff)
SHEAR_STRENGTH=4;
boardSheer = ((1/coeff) * SHEAR_STRENGTH * I * b)/Q;
end

function glueSheerVal = glueSheer(b,I,Q, coeff)

SHEAR_GLUE=2;
glueSheerVal = ((1/coeff)* SHEAR_GLUE * I * b)/Q;
end

%Plate Buckling 
function pr = plateRest(t,b,stress)
E=4000;
POISS_RATIO=.2;
temp = (4 * pi^2 * E)/(12*(1-POISS_RATIO^2)) * (t/b)^2;
pr = temp/stress;
end

function pte = plateOneEdge(t,b,stress)
E=4000;
POISS_RATIO=.2;
temp = (.425 * pi^2 * E)/(12*(1-POISS_RATIO^2)) * (t/b)^2;
pte = temp/stress;
end

function psb = plateSheerBuckling(t,h,a,stress)
E=4000;
POISS_RATIO=.2;
temp = (6 * pi^2 * E)/(12*(1-POISS_RATIO^2)) * ((t/h)^2 + (t/a)^2);
psb = temp/stress;
end

