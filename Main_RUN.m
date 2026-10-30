clc;
clear;
close all;

%% Data Initialization
x1=readtable("T1.csv");

Power=table2array(x1(:,2)); % Signal
Power=Power(1:length(Power)); % Noisy Signal

NPower=Power'+200*randn(1,length(Power));
x= NPower;
Predict_Load_Actual=x;

Target=x;

%% Wavelet

nLevel=3;

[A, D]=GetDWT(x,nLevel,'db5');

[PA, PD]=GetDWT(Predict_Load_Actual,nLevel,'db5');

nx=numel(x);

Delays=[1 5 10];

MaxDelay=max(Delays);

Range=(MaxDelay+1):nx;

Inputs=[];

c=0;

% Train and Test

for i=1:numel(Delays) 
   for k=1:nLevel
        c=c+1;
        Inputs(c,:) = A{k}(Range-Delays(i));
        c=c+1;
        Inputs(c,:) = D{k}(Range-Delays(i));
   end
end

% Day ahead Prediction
 c1=0;
   for k=1:nLevel
        c1=c1+1;
        Inputs_P(c1,:) = PA{k};
        c1=c1+1;
        Inputs_P(c1,:) = PD{k};
   end


X=Inputs';
Y=Target';

XP=Inputs_P';

YP=Predict_Load_Actual;

%% NN
DataNum = size(X,1);

InputNum = size(X,2);

OutputNum = size(Y,2);

%% Normalization

MinX = min(X);

MaxX = max(X);

MinX_P = min(XP);

MaxX_P = max(XP);

MinY = min(Y);

MaxY = max(Y);

MinY_P = min(YP);

MaxY_P = max(YP);

XN = X;
labels=randi([0, 1], size(XN,1), 1);
YN = Y;
Q = size(XN,2);  % Sort all Features and Select the top 10 features

% Call the MI function
[selected_features,W] = MI(XN, labels, Q);
XN=XN(:,selected_features(1:end-5));
Q = size(XN,2);
selected_features1 = MI2(XN, labels, Q,Q);
XN=XN(:,selected_features1(1:end-5));

% XN=XN(:,selected_features(1:10));
% XN=XN(:,selected_features1(1:10));
XN_P = normalize(XP);
YN_P = normalize(YP);

% for ii = 1:InputNum
% 
%     XN(:,ii) = Normalize_Fcn(X(:,ii),MinX(ii),MaxX(ii));
% end
% 
% for ik=1:size(XP,2)
% 
%     XN_P(:,ik) = Normalize_Fcn(XP(:,ik),MinX_P(ik),MaxX_P(ik));
% end
% 
% for ii = 1:OutputNum
% 
%     YN(:,ii) = Normalize_Fcn(Y(:,ii),MinY(ii),MaxY(ii));
% end
% 
% for ik2=1:size(YP,2)
% 
%     YN_P(:,ik2) = Normalize_Fcn(YP(:,ik2),MinY_P(ik2),MaxY_P(ik2));
% 
% end

%% Test and Train Data
TrPercent = 80;
TrNum = round(DataNum * TrPercent / 100);
TsNum = DataNum - TrNum;

R = randperm(DataNum);
trIndex = R(1 : TrNum);
tsIndex = R(1+TrNum : end);

Xtr = XN(trIndex,:);
Ytr = YN(trIndex,:);

Xts = XN(tsIndex,:);
Yts = YN(tsIndex,:);

YN1=YN(1:24);

%% Network Structure
pr = [-1 1];
PR = repmat(pr,InputNum,1);

Network_NN = newff(PR,[5 OutputNum],{'tansig' 'tansig'}); % Neural Network

Network_RBF = newrb(Xtr',Ytr',0,1,5,1);                   % RBF Neural NEtWork

[tt,SVm]=SVM_NN(XN);                                           % SVM


%% Training
 Network_NN   = TrainUsing_ABC_Fcn(Network_NN,Xtr,Ytr);

 Network_RBF  = TrainUsing_ABC_Fcn(Network_RBF,Xtr,Ytr);

%% Assesment For NN

YtrNet = sim(Network_NN,Xtr')';

YtsNet = sim(Network_NN,Xts')';

SimAll = sim(Network_NN,XN')';

%% Assesment For RBF
YtrNet_RBF = sim(Network_RBF,Xtr')';

YtsNet_RBF = sim(Network_RBF,Xts')';

SimAll_RBF = sim(Network_RBF,XN')';


%% Fusion Algorithm 

[Classification_accuracy,p1,alpha1,classes,OW1,OW2]=OWAA(YtrNet_RBF , YtrNet, SVm,XN);

%% MSE

MSEtr_NN = mse(YtrNet - Ytr)
MSEts_NN = mse(YtsNet - Yts)


MSEtr_RBBF = mse(YtrNet_RBF - Ytr)
MSEts_RBF =  mse(YtsNet_RBF - Yts)

%% Display NN

figure(1)
plot(Ytr,'-or');
hold on
plot(YtrNet,'-sb');
hold off
legend('Actual Data','Predicted')

figure(2)
plot(Yts,'-or');
hold on
plot(YtsNet,'-sb');
hold off
legend('Actual Data','Predicted')

figure(3)
t = -1:.1:1;
plot(t,t,'b','linewidth',2)
hold on
plot(Ytr,YtrNet,'ok')
hold off

figure(4)
t = -1:.1:1;
plot(t,t,'b','linewidth',2)
hold on
plot(Yts,YtsNet,'ok')
hold off

figure(5)
plot(YN(31:48))
 hold on
plot(SimAll(31:48))
 hold off
legend('Actual Data','Predicted')
title('Day ahead Load Prediction')

MSE_day_Ahead=mse(SimAll,YN1)


figure(8);
plot(OW1(19:40),'k:o');
hold on;
plot(OW2(19:40),'r-s');
hold off


% figure(8);
% plot(OW1(19:40),'k:o');
% hold on;
% plot(OW2(19:40),'r-s');
% hold off



%% Display RBF
% figure(6)
% plot(Ytr,'-or');
% hold on
% plot(YtrNet_RBF,'-sb');
% hold off
% legend('Actual Data','Predicted')
% 
% figure(7)
% plot(Yts,'-or');
% hold on
% plot(YtsNet_RBF,'-sb');
% hold off
% legend('Actual Data','Predicted')
% 
% figure(8)
% t = -1:.1:1;
% plot(t,t,'b','linewidth',2)
% hold on
% plot(Ytr,YtrNet_RBF,'ok')
% hold off
% 
% figure(9)
% t = -1:.1:1;
% plot(t,t,'b','linewidth',2)
% hold on
% plot(Yts,YtsNet_RBF,'ok')
% hold off
% 
% figure(10)
% plot(YN1(end-24:end))
%  hold on
% plot(SimAll_RBF(end-24:end))
%  hold off
% legend('Actual Data','Predicted')
% title('Day ahead Load Prediction')
% 
% MSE_day_Ahead=mse(SimAll_RBF,YN1)
% 
% for i =1:50
% 
% kkk(i,:)=[kk./(0.001*i)];
% 
% end



