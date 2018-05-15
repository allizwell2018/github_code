%dbstop at 74 in restingFunConn

subdir='/DATA/236/dywu/HCP1200/data';
%subdir='/DATA/249/xli/HCP_DTI/data_40';
scriptroot='/DATA/235/dywu/HCP1200/script';
roi210dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf210');
roi380dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf380');

%addpath /home/dywu/spm12

sublist      = struct2cell(dir(subdir))';  % list folder content
sublist      = char(sublist(:,1));              % convert to string
sublist(sublist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.sublist = size(sublist,1);                 % # of sublists
sublist      = cellstr(sublist);                % make cell array (for convenience) 


roi210list      = struct2cell(dir(fullfile(roi210dir,'*.txt')))';  % list folder content
roi210list      = char(roi210list(:,1));              % convert to string
roi210list(roi210list(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roi210list = size(roi210list,1);                 % # of sublists
roi210list      = cellstr(roi210list);                % make cell array (for convenience) 

roi380list      = struct2cell(dir(fullfile(roi380dir,'*.txt')))';  % list folder content
roi380list      = char(roi380list(:,1));              % convert to string
roi380list(roi380list(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roi380list = size(roi380list,1);                 % # of sublists
roi380list      = cellstr(roi380list);                % make cell array (for convenience) 


%%

for i=1:num.sublist
    
    fprintf('calculating snr of %s \n',sublist{i})
    
    tdata1 = load(fullfile(subdir,sublist{i},'MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.txt'));
    tdata2 = load(fullfile(subdir,sublist{i},'MNINonLinear/Results/rfMRI_REST1_RL/rfMRI_REST1_RL_Atlas_MSMAll_hp2000_clean.txt'));
    tdata3 = load(fullfile(subdir,sublist{i},'MNINonLinear/Results/rfMRI_REST2_LR/rfMRI_REST2_LR_Atlas_MSMAll_hp2000_clean.txt'));
    tdata4 = load(fullfile(subdir,sublist{i},'MNINonLinear/Results/rfMRI_REST2_RL/rfMRI_REST2_RL_Atlas_MSMAll_hp2000_clean.txt'));
    
    noise1(:,i)=mean(tdata1,2)./(std(tdata1,1,2)+1e-10);
    noise2(:,i)=mean(tdata2,2)./(std(tdata2,1,2)+1e-10);
    noise3(:,i)=mean(tdata3,2)./(std(tdata3,1,2)+1e-10);
    noise4(:,i)=mean(tdata4,2)./(std(tdata4,1,2)+1e-10);
    
    
end
result_path = '/DATA/236/dywu/HCP1200/prediction_fmri/snrall';
mkdir(result_path)
snr1=mean(noise1,2);snr2=mean(noise2,2);snr3=mean(noise3,2);snr4=mean(noise4,2);
snrall=(snr1+snr2+snr3+snr4)/4;
dlmwrite(fullfile(result_path,'snrall.txt'),snrall,'delimiter',' ','newline', 'pc','-append')


