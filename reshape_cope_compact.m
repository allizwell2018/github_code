function [ result_all_reshape ] = reshape_cope_compact( result_all )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
    %clear
%load result_resting_4merge_task
%load result_dti_task
TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
%TaskList={'MOTOR'} ;
num.task=length(TaskList);

result_all_reshape{1} = result_all{1};
result_all_reshape{2} = result_all{2};
result_all_reshape{3} = result_all{3};
result_all_reshape{5} = result_all{5};
result_all_reshape{6} = result_all{6};

result_all_reshape{4}(:,1) = result_all{4}(:,1);
result_all_reshape{4}(:,2:9) = result_all{4}(:,6:13);
result_all_reshape{4}(:,10:13) = result_all{4}(:,2:5);

result_all_reshape{7}(:,1) = result_all{7}(:,1);
result_all_reshape{7}(:,2) = result_all{7}(:,9);
result_all_reshape{7}(:,3:9) = result_all{7}(:,13:19);
result_all_reshape{7}(:,10:16) = result_all{7}(:,2:8);
result_all_reshape{7}(:,17:19) = result_all{7}(:,10:12);


end

