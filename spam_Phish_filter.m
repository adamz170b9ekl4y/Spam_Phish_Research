%% Spam_Phish_Filter
%Filtering script for Spam Phish research study
%
%
%
%
clear all; clc; 
subject_list ={'222','429','432','852','853','866','928','941','961','1035','1038','1040','1045','1051','1052','1053'}; %subject list
epev={'10','13','15','16','17','18','19','20','22','23','24','25','26','27','28','29','110','113','115','116','117','118',...
'119','120','122','123','124','125','126','127','128','129','210','213','215','216','217','218','219','220','222','223',...
'224','225','226','227','228','229'};%Possible Epoch Events
numsubjects = length(subject_list);%number of subjects;

parentfolder = 'K:\Neurolab\Phish_Spam\Raw Data';
childfolder = 'K:\Neurolab\Phish_Spam\m files';
%above should be changed depending on directory

blocks = {'1','2','3'};%block numbers
numblocks = length(blocks);
epochLimits = [-1,11.5];

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
for s=1:numsubjects
    
    subject = subject_list{s};%Get current subject
    i = subject_list{s};
    subjectfolder = [parentfolder '\' i ];
    outputfolder = [childfolder '\' i];
    for b = 1:numblocks
        j = blocks{b};
           blockfolder = [subjectfolder '\' subject '_PS_A_' j '.dap'];
           filecheck1 =   [subjectfolder '\' subject '_PS_A_' j '.dat'];
           filecheck2 =   [subjectfolder '\' subject '_PS_A_' j '.rs3'];

         %used to check for necessary associated files .dat and .rs3
          
        if exist(blockfolder)==2 && exist(filecheck1)==2 && exist(filecheck2)==2
            %Checks if subject block exists (if exist condition is returned
            %true)
         fprintf('\n Processing subject: %s block: %d \n',i,b);
         EEG = loadcurry(blockfolder, 'CurryLocations', 'False');%File location
         EEG = eeg_checkset(EEG);%Check the consistency of fields of an EEG dataset.
    
         EEG = pop_eegfiltnew(EEG, 'locutoff',1); % Highpass filter 1Hz
         EEG = pop_eegfiltnew(EEG, 'hicutoff',60); % lowpass filter 60Hz
         
         EEG = pop_epoch(EEG,epev,epochLimits);%Epoch all events of current EEG base on limits.
         EEG = eeg_checkset( EEG );
         EEG = pop_rmbase(EEG, [-1000 0]); %Baseline removal
         eeglab redraw;
         
         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
         fprintf('\n Save subject as: %s block: %d \n',i,b);
         Filteredfilename = [subject '_A_Filtered_' j '.set'];
         pop_saveset(EEG,'filename', Filteredfilename,'filepath',outputfolder);
         
         eeglab redraw;
        else
            fprintf('\n Warning! Subject: %s block: %d is missing \n',i,b);
            fprintf('Check if .dap .dat and .rs3 files are present\n');
            fprintf('if not, manual filtering may be necessary\n');
        end
    end
end