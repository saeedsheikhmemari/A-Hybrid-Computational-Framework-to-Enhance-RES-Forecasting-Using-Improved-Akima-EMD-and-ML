
function [Classification_accuracy,p1,alpha1,classes,OW1,OW2] = OWAA(DA,DB,DC,Xd) % data file
DC=DC;
data=[DA  DB];
%Dividing it to testing and learning sets to this example.
datalearn=[data(1:25,:);data(51:75,:);data(101:125,:)];
datatest=[data(26:50,:);data(76:100,:);data(126:150,:)];
v=[1:2];
c=2;
measure = 1; % Which quantifier to use in OWA operators you want to use. 
% Possible choices implemented:
% 1=Basic RIM quantifier
% 2=Quadratic quantifier
% 3=Exponential quantifier
% 4=Trigonometric quantifier
% 5=O'Hagans method. Note: in this case alpha in [0,1]
p = 1; % p parameter range
alpha = 1; % for different alpha values in generating weights for OWA 
pl=1; % Do we use plotting w.r.t. parameters p and m or not pl=0 no plotting pl=1 plotting. 

[Classification_accuracy,p1,alpha1,classes,OW1,OW2]=simo1(datalearn, datatest,v,c, measure, p, alpha,Xd);
Classification_accuracy


disp('Or if you just want to classify with one parameter values i.e. p=1,alpha=1')
[Classification_accuracy,p1,m1,classes,OW1,OW2]=simo1(datalearn, datatest,v,c, measure, 1, 1,Xd);
Classification_accuracy


end