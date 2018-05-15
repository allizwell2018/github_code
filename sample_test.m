%%
TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
ContrastList = { {'FACES','SHAPES','FACES-SHAPES'},{'PUNISH','REWARD','PUNISH-REWARD'},{'MATH','STORY','STORY-MATH'},...
    {'CUE','LF','LH','RF','RH','T','AVG','CUE-AVG','LF-AVG','LH-AVG','RF-AVG','RH-AVG','T-AVG'},...
    {'MATCH','REL','REL-MATCH'},{'RANDOM','TOM','TOM-RANDOM'},{'2BK_BODY','2BK_FACE','2BK_PLACE','2BK_TOOL','0BK_BODY',...
    '0BK_FACE','0BK_PLACE','0BK_TOOL','2BK','0BK','2BK-0BK','BODY','FACE','PLACE','TOOL','BODY-AVG','FACE-AVG','PLACE-AVG','TOOL-AVG'} };

acc=[]; i=5;m=2;
samplenum=[1 5 10 20 30 40 50 60 70 80];
load result_resting_sample1.mat
acc=[acc result_all{i}(1,m)];
load result_resting_sample5.mat
acc=[acc result_all{i}(1,m)];
load result_resting_sample10.mat
acc=[acc result_all{i}(1,m)];
load result_resting_sample20.mat
acc=[acc result_all{i}(1,m)];
load result_resting_sample30.mat
acc=[acc result_all{i}(1,m)];
load result_resting_sample40.mat
acc=[acc result_all{i}(1,m)];
load result_resting_sample50.mat
acc=[acc result_all{i}(1,m)];
load result_resting_sample60.mat
acc=[acc result_all{i}(1,m)];
load result_resting_sample70.mat
acc=[acc result_all{i}(1,m)];
load result_resting_sample80.mat
acc=[acc result_all{i}(1,m)];

plot(samplenum,acc)
xlabel('Number of training subjects')
ylabel('Prediction accuracy')
title([TaskList{i} ['  ',ContrastList{i}{m}]],'FontName','Times New Roman','FontSize',15,'FontWeight','bold');
