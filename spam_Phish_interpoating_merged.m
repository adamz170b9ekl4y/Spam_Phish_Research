%% Spam_Phish_Interpoating_Merged
%Script responsible for combining subject trial secessions (blocks)
%into one file.
%Script will pause and plot channels along with EEGLAB channel interpolation menu 
%After reviewing file and identifying channels in need of interpolation, script will
%then interpolate these channels and save output.
clear all; clc; 
subject_list={'222','429','432','852','853','866','928','941','961','1035','1038','1040','1045','1051','1052','1053'}; %subject list
numsubjects = length(subject_list);%number of subjects;

parentfolder = 'K:\Neurolab\Phish_Spam\m files';
%above should be changed depending on directory

blocks = {'1','2','3'};%block numbers
numblocks = length(blocks);
blockcheck = 0;
x=1;y=2;z=3;

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for s=1:numsubjects
    
    fprintf(subject_list{s}); 
   
    subject = subject_list{s};%Get current subject
    i = subject_list{s};
    subjectfolder = [parentfolder  '\' i ];
    
    for b = 1:numblocks
        j = blocks{b};
        blockfolder = [subjectfolder '\' subject '_A_Filtered_' j '.set'];
         CurrentSet = [subject '_A_Interpo' j '.set'];
         
          filecheck1 =   [subjectfolder '\' subject '_A_Filtered_' j '.fdt'];
         %used to check for necessary associated files .fdt
               
            filename = [subject '_A_Filtered_' j];
            file = [subject '_A_Filtered_' j '.set'];
         %used for pop_loadset method
        
        if exist(blockfolder)==2 && exist(filecheck1) %Checks if subject block exists
            
            EEG = pop_loadset('filename',file,'filepath',subjectfolder);
           
            [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
            blockcheck = blockcheck+1;
            else
            fprintf('\n Warning! Subject: %f block: %f is missing \n',s,b);
            fprintf('Check if .set and .fdt files is present\n');
        end
    end
    eeglab redraw;
    
        %Merge blocks into one EEG set
        if blockcheck == 3
            indices = [x,y,z];
            MergedEEG = pop_mergeset(ALLEEG, indices,0);
            x = x+3;
            y = y+3;
            z = z+3;
            
        elseif blockcheck == 2
            indices = [x,y];
            MergedEEG = pop_mergeset(ALLEEG, indices,0);
            x = x+2;
            y = y+2;
            z = z+2;
            
        elseif blockcheck == 1
            indices = x;
            MergedEEG = pop_mergeset(ALLEEG, indices,0);
            x = x+1;
            y = y+1;
            z = z+1;
        end
        eeglab redraw;
        pop_eegplot(MergedEEG,1,1,1);
        ud =get(gcf,'UserData');
        ud.winlength = 5;
        set(gcf,'UserData',ud);
        eegplot('draws',0)
		
         MergedEEG=pop_chanedit(MergedEEG,'load','K:\Neurolab\Phish_Spam\64 ch_EEGLab.ced','filetype','autodetect');
         MergedEEG=pop_chanedit(MergedEEG, 'changefield',{60 'labels' 'PO9'},...
         'lookup','C:\Users\aju988\Desktop\Eeglab\eeglab14_1_2b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp',...
         'changefield',{64 'labels' 'PO10'},'lookup','C:\Users\aju988\Desktop\Eeglab\eeglab14_1_2b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp');
         MergedEEG = pop_select( MergedEEG,'nochannel',{'HEO','VEO'});
         MergedEEG = pop_interp(MergedEEG);
        
        uiwait;
   
         MergedEEG = eeg_checkset( MergedEEG );
         
        MergedEEG = pop_reref( MergedEEG, []); %Average Reference 
            
       [ALLEEG, MergedEEG, CURRENTSET] = eeg_store( ALLEEG, MergedEEG, 0 );
       Interpofilename = [subject '_A_InterpoMerged.set'];
       pop_saveset(MergedEEG,'filename', Interpofilename,'filepath',subjectfolder);
       eeglab redraw;
 
        %Advance k and reset blockcheck for next subject
 
        blockcheck = 0;
end