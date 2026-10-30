function [Classification_accuracy,p1,m1,classes,t,y1]=simo1(datalearn, datatest,v,c, measure, p, m,xd)
%Inputs:
% datalearn: put your data file in matrix form, rows indicates samples and
% columns features of the data.
% datatest: put your data file in matrix form, rows indicates samples and
% columns features of the data.
% v:   how many columns of features you are using e.g. [1:4] means you will
% use first four columns as features of your data.
% c: column where you class labels are. They should be in numerical form.
% measure: Which quantifier in OWA operators you want to use. 
% 1=Basic RIM quantifier
% 2=Quadratic quantifier
% 3=Exponential quantifier
% 4=Trigonometric quantifier
% 5=O'Hagans method.
% p: parameter in generalized Lukasiewics similarity, can be studied as a range of
% parameter values and then given as a vector i.e. p=[0.1:0.1:5].
% alpha: alpha value in OWA operators.
% Can be given as vector i.e. alpha=[0.1:0.1:5].
% pl: do you want to plot how the parameter changes in p and alpha changes the
% mean classification accuracies and variances.
%
%OUTPUTS:
% Mean_accuracy: Mean classification accuracy with best parameter values in
% p and m:
% p1 and m1: best parameter values w.r.t. mean classification accuracy.
% classes: Class information. To which class the sample was classified (in testing set data, datatest) 

sv_name = 'results1'; % mat file where results are stored ('' = "no storing")

[datatest, lc1, cs1] = init_data(datatest,v,c); 
[datalearn, lc2, cs2] = init_data(datalearn,v,c); 

w_opt = 0; % Do we use weight optimization. Not implemented in this version.

%Initializations
N=1;
rn=1;
fitness = zeros(1,N);
fitness_id = zeros(1,N);
fitness_dif = zeros(1,N);
Means = zeros(length(p),length(m),length(rn));
Vars = zeros(length(p),length(m),length(rn)); 
Maxsf = zeros(length(p),length(m),length(rn));
Minsf = zeros(length(p),length(m),length(rn));

Means_fit_dif = zeros(length(p),length(m),length(rn));
Vars_fit_dir = zeros(length(p),length(m),length(rn)); 
Ideal_var = zeros(length(p),length(m), length(lc1),length(rn));
Mindata = min(xd);

Maxdata = max(xd);

for ii = 1:numel(xd)

    XN(ii) = Normalize_Fcn(xd(ii),Mindata,Maxdata);
end


s=XN(1:200);
Delays=[6 12 18 24];
nDelay=numel(Delays);

MaxDelay=max(Delays);

N=numel(s);
Range=(MaxDelay+1):N;


x = zeros(nDelay,numel(Range));
for k=1:nDelay
    d=Delays(k);
    x(k,:)=s(Range-d);
end

t = s(Range);

n=numel(t);


epsilon=0.02;

C=1000;

sigma=0.5;

Kernel=@(xi,xj) exp(-1/(2*sigma^2)*norm(xi-xj)^2);

H=zeros(n,n);
for i=1:n
    for j=i:n
        H(i,j)=Kernel(x(:,i),x(:,j));
        H(j,i)=H(i,j);
    end
end

HH=[ H -H
    -H  H];

f=[-t'; t']+epsilon;

Aeq=[ones(1,n) -ones(1,n)];
beq=0;

lb=zeros(2*n,1);
ub=C*ones(2*n,1);

options=optimset('Display','iter','MaxIter',1000);

alpha=quadprog(HH,f,[],[],Aeq,beq,lb,ub,[],options);

alpha=alpha';

AlmostZero=(abs(alpha)<max(abs(alpha))*1e-4);

alpha(AlmostZero)=0;

alpha_plus=alpha(1:n);
alpha_minus=alpha(n+1:end);

eta=alpha_plus-alpha_minus;

S=find(alpha_plus+alpha_minus>0 & alpha_plus+alpha_minus<C);

y1=zeros(size(t));
for i=1:n
    y1(i)=MySVRFunc(x(:,i),eta(S),x(:,S),Kernel);
end

b=mean(t(S)-y1(S)-sign(eta(S))*epsilon);

y1=y1+b;
for n = 1 : 1
    rn_ideal = ones(1,length(lc1)); 
    for j = 1:length(m)    
        for i = 1:length(p)  
            y = [p(i), m(j),measure]; % p and m values and similarity measure
        
            for k = 1 : 1 
                ideals(:,:,k) = idealvectors(datalearn, y); % idealvectors         
                if w_opt == 0  
                  [fitness(k), class, Simil] = calcfit(datatest, ideals(:,:,k), y);
                end
            end
            classinfo(i,j,1:length(class))=class;
            Means(i,j,n) = mean(fitness);
            Vars(i,j,n) = var(fitness);
            Maxsf(i,j,n) = max(fitness);
            Minsf(i,j,n) = min(fitness);
            fitness=[];
        end    
    end
    tmp=max(max(Means));
    [p1,m1]=find(tmp==Means);
    Classification_accuracy=Means(p1(1),m1(1));
    classes=classinfo(p1(1),m1(1),:);
    clear Y
end

if length(sv_name) ~= 0
    save(sv_name)
end