function [ result_all_reshape ] = reshape_cope( result_all )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
    %clear
%load result_resting_4merge_task
%load result_dti_task
TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
%TaskList={'MOTOR'} ;
num.task=length(TaskList);

for i=1:num.task
    num.copelist=length(result_all{i});
    if num.copelist >=10 && num.copelist <= 19
%         result_reshape{i}(1) = result{i}(1);
%         result_reshape{i}(2:9) = result{i}(num.copelist-8+1:end);
%         result_reshape{i}(10:num.copelist) = result{i}(2:num.copelist-9+1);
        
        result_all_reshape{i}(:,1) = result_all{i}(:,1);
        result_all_reshape{i}(:,2:9) = result_all{i}(:,num.copelist-8+1:end);
        result_all_reshape{i}(:,10:num.copelist) = result_all{i}(:,2:num.copelist-9+1);
        
    elseif num.copelist >=20 && num.copelist <= 29
%         result_reshape{i}(1) = result{i}(1);
%         result_reshape{i}(2) = result{i}(12);
%         result_reshape{i}(3:9) = result{i}(num.copelist-7+1:end);
%         result_reshape{i}(10:19) = result{i}(2:11);
%         result_reshape{i}(20:num.copelist) = result{i}(13:num.copelist-8+1);
        
        result_all_reshape{i}(:,1) = result_all{i}(:,1);
        result_all_reshape{i}(:,2) = result_all{i}(:,12);
        result_all_reshape{i}(:,3:9) = result_all{i}(:,num.copelist-7+1:end);
        result_all_reshape{i}(:,10:19) = result_all{i}(:,2:11);
        result_all_reshape{i}(:,20:num.copelist) = result_all{i}(:,13:num.copelist-8+1);               
        
    elseif num.copelist >=30 && num.copelist <= 39
%         result_reshape{i}(1) = result{i}(1);
%         result_reshape{i}(2) = result{i}(12);
%         result_reshape{i}(3) = result{i}(23);
%         result_reshape{i}(4:9) = result{i}(num.copelist-6+1:end);
%         result_reshape{i}(10:19) = result{i}(2:11);
%         result_reshape{i}(20:29) = result{i}(13:22);
%         result_reshape{i}(30:num.copelist) = result{i}(24:num.copelist-7+1);
        
        result_all_reshape{i}(:,1) = result_all{i}(:,1);
        result_all_reshape{i}(:,2) = result_all{i}(:,12);
        result_all_reshape{i}(:,3) = result_all{i}(:,23);
        result_all_reshape{i}(:,4:9) = result_all{i}(:,num.copelist-6+1:end);
        result_all_reshape{i}(:,10:19) = result_all{i}(:,2:11);
        result_all_reshape{i}(:,20:29) = result_all{i}(:,13:22);
        result_all_reshape{i}(:,30:num.copelist) = result_all{i}(:,24:num.copelist-7+1);
    else
%         result_reshape{i} = result{i};

        result_all_reshape{i} = result_all{i};
        
    end
             
end
result_all_reshape{1}(4:6)=[];
result_all_reshape{2}(4:6)=[];
result_all_reshape{3}([3,5,6])=[];
result_all_reshape{4}(14:26)=[];
result_all_reshape{5}([3,5,6])=[];
result_all_reshape{6}(3:5)=[];
result_all_reshape{7}(23:30)=[];
result_all_reshape{7}(12:14)=[];

% result_all_reshape{1}(:,4:6)=[];
% result_all_reshape{2}(:,4:6)=[];
% result_all_reshape{3}(:,4:6)=[];
% result_all_reshape{4}(:,14:26)=[];
% result_all_reshape{5}(:,4:6)=[];
% result_all_reshape{6}(:,4:6)=[];
% result_all_reshape{7}(:,23:30)=[];
% result_all_reshape{7}(:,12:14)=[];


end

