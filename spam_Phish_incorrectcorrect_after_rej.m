%% Spam_Phish_Incorrect/correct_after_rej
%Preprocessing script for Spam Phish research study
%Script takes in subject test conditions for Spam/Phish
%Script then separates subject file into files containing
%desired conditions
%
subject_list = {'222','429','432','852','853','866','916','928','941','961','1035','1038','1040','1045'}; %subject list, reads all 
numsubjects = length(subject_list);%number of subjects;

parentfolder = 'K:\Neurolab\Phish_Spam\m files';
%above should be changed depending on directory

phishId = [20,22,23,24,25,26,27,28,29,120,122,123,124,125,126,127,128,129 ...
    ,220,222,223,224,225,226,227,228,229];%All possible Phish ids

phishIdLength = length(phishId);%get length of phishId for loop
        
spamId = [10,13,15,16,17,18,19,110,113,115,116,117,118,119,210,213,215,216 ...
    ,217,218,219];%All possible spam ids

spamIdLength = length(spamId);%get length of spamId for loop

phishCorrect = []; %Creates vectors for all possible T/F
phishIncorrect = [];
spamCorrect = [];
spamIncorrect = [];
spam123 =[];
spam456 =[];
spam789 = [];
phish123 = [];
phish456 = [];
phish789 = [];

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab; %load eeglab

%% Main Program
for s=1:numsubjects
    
    fprintf(subject_list{s}); 
    fprintf('\n');
    %Ask what the spam and Phish values were.
    spamPrompt = 'What was the spam value?\n';
        spam = input(spamPrompt);
    phishPrompt = 'What was the Phish value?\n';
        phish = input(phishPrompt);
    
        if spam == 1 || spam == 2 && phish == 8 || phish == 4
            s1 = 100001;
            s2 = 100002;
            p1 = 100004;
            p2 = 100008;
            
           elseif spam == 8 || spam == 4 && phish ==1 || phish == 2 
                p1 = 100001;
                p2 = 100002;
                s1 = 100004;
                s2 = 100008;
        else
             fprintf('Invalid input, please enter value of 1,2,4 or 8');
        end
    
    subject = subject_list{s};%Get current subject
    i = subject_list{s};
    subjectfolder = [parentfolder  '\' i ];
    filename = [subject '_merged'];
    file = [subject '_merged_rej.set'];
    MergedEEG = pop_loadset('filename',file,'filepath',subjectfolder);
    MergedEEG = eeg_checkset(MergedEEG);
        %For length of EEG events, catalogue trials into Spam/Phish
        %Correct/Incorrect events
        EEGeventLength = length(MergedEEG.event);
        for l = 1:EEGeventLength
            for m = 1:phishIdLength
                if MergedEEG.event(l).type == phishId(m) && l ~= EEGeventLength
                    
                    x = MergedEEG.event(l).type;
                    d = 100;
                    r = mod(x,d);
                    y = mod(r,10);
                    if y == 1 || y == 2 || y ==3
                        phish123(end+1) = MergedEEG.event(l).epoch;
                    elseif y == 4 || y == 5 || y == 6
                        phish456(end+1) = MergedEEG.event(l).epoch;
                    elseif y == 7 || y == 8 || y == 9
                        phish789(end+1) = MergedEEG.event(l).epoch;
                    end
                    
                    if MergedEEG.event(l+1).type == p1 || MergedEEG.event(l+1).type == p2
                        
                        phishCorrect(end+1) = MergedEEG.event(l).epoch;
                        phishCorrect(end+1) = MergedEEG.event(l+1).epoch;
   
                    elseif MergedEEG.event(l+1).type == s1 || MergedEEG.event(l+1).type == s2
                       
                        phishIncorrect(end+1) = MergedEEG.event(l).epoch;
                        phishIncorrect(end+1) = MergedEEG.event(l+1).epoch;
                    
                    end       
                end
            end
            for m = 1:spamIdLength
                if MergedEEG.event(l).type == spamId(m) && l ~= EEGeventLength
                    
                    x = MergedEEG.event(l).type;
                    d = 100;
                    r = mod(x,d);
                    y = mod(r,10);
                    if y == 1 || y == 2 || y ==3
                        spam123(end+1) = MergedEEG.event(l).epoch;
                    elseif y == 4 || y == 5 || y == 6
                        spam456(end+1) = MergedEEG.event(l).epoch;
                    elseif y == 7 || y == 8 || y == 9
                        spam789(end+1) = MergedEEG.event(l).epoch;
                    end
                    
                   if MergedEEG.event(l+1).type == s1 || MergedEEG.event(l+1).type == s2
                      
                       spamCorrect(end+1) = MergedEEG.event(l).epoch;
                       spamCorrect(end+1) = MergedEEG.event(l+1).epoch;
                   elseif MergedEEG.event(l+1).type == p1 || MergedEEG.event(l+1).type == p2
                      
                       spamIncorrect(end+1) = MergedEEG.event(l).epoch;
                       spamIncorrect(end+1) = MergedEEG.event(l+1).epoch;
                   end
                end
            end
        end
        
        %Separate MergedEEG into separate Spam/Phish correct/incorrect datasets 
        
        EEGSpamCorrect = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',spamId ,'epoch',spamCorrect ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEGSpamIncorrect = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',spamId ,'epoch',spamIncorrect ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEGPhishCorrect = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',phishId ,'epoch',phishCorrect ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEGPhishIncorrect = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',phishId ,'epoch',phishIncorrect ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEGPhish123 = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',phishId ,'epoch',phish123 ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEGPhish456 = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',phishId ,'epoch',phish456 ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEGPhish789 = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',phishId ,'epoch',phish789 ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEGSpam123 = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',spamId ,'epoch',spam123 ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEGSpam456 = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',spamId ,'epoch',spam456 ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEGSpam789 = pop_selectevent( MergedEEG, 'latency','-1<=11.5','type',spamId ,'epoch',spam789 ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        %Name and save files
        
        Spamcsetname = [subject '_Sp_C'];
        Spamicsetname = [subject '_Sp_Ic'];
        Phishcsetname = [subject '_Ph_C'];
        PhishIcsetname = [subject '_Ph_Ic'];
        Spam123Name = [subject '_Sp_123'];
        Spam456Name = [subject '_Sp_456'];
        Spam789Name = [subject '_Sp_789'];
        Phish123Name = [subject '_Ph_123'];
        Phish456Name = [subject '_Ph_456'];
        Phish789Name = [subject '_Ph_789'];
        
        EEGSpamCorrect = pop_editset(EEGSpamCorrect, 'setname',Spamcsetname);
        EEGSpamIncorrect = pop_editset(EEGSpamIncorrect, 'setname', Spamicsetname);
        EEGPhishCorrect = pop_editset(EEGPhishCorrect, 'setname',Phishcsetname );
        EEGPhishIncorrect = pop_editset(EEGPhishIncorrect, 'setname', PhishIcsetname);
        
        EEGPhish123 = pop_editset(EEGPhish123,'setname',Phish123Name);
        EEGPhish456 = pop_editset(EEGPhish456,'setname',Phish456Name);
        EEGPhish789 = pop_editset(EEGPhish789,'setname',Phish789Name);
        
        EEGSpam123 = pop_editset(EEGSpam123,'setname',Spam123Name);
        EEGSpam456 = pop_editset(EEGSpam456,'setname',Spam456Name);
        EEGSpam789 = pop_editset(EEGSpam789,'setname',Spam789Name);
        
        SpamCfilename = [subject '_Sp_C_rej.set'];
        pop_saveset(EEGSpamCorrect,'filename', SpamCfilename,'filepath',subjectfolder);
        
        SpamIcfilename = [subject '_Sp_Ic_rej.set'];
        pop_saveset(EEGSpamIncorrect,'filename', SpamIcfilename,'filepath',subjectfolder);
        
        PhishCfilename = [subject '_Ph_C_rej.set'];
        pop_saveset(EEGPhishCorrect,'filename', PhishCfilename,'filepath',subjectfolder);
        
        PhishIcfilename = [subject '_Ph_Ic_rej.set'];
        pop_saveset(EEGPhishIncorrect,'filename', PhishIcfilename,'filepath',subjectfolder);
        
        Spam123filename = [subject '_Sp_123_rej.set'];
        pop_saveset(EEGSpam123,'filename',Spam123filename,'filepath',subjectfolder);
        Spam456filename = [subject '_Sp_456_rej.set'];
        pop_saveset(EEGSpam456,'filename',Spam456filename,'filepath',subjectfolder);
        Spam789filename = [subject '_Sp_789_rej.set'];
        pop_saveset(EEGSpam789,'filename',Spam789filename,'filepath',subjectfolder);
 
        Phish123filename = [subject '_Ph_123_rej.set'];
        pop_saveset(EEGPhish123,'filename',Phish123filename,'filepath',subjectfolder);
        Phish456filename = [subject '_Ph_456_rej.set'];
        pop_saveset(EEGPhish456,'filename',Phish456filename,'filepath',subjectfolder);
        Phish789filename = [subject '_Ph_789_rej.set'];
        pop_saveset(EEGPhish789,'filename',Phish789filename,'filepath',subjectfolder);
        
end
            