%% Cluster Analysis
%Script is to get average for each time and freq range of
%ERSP data for each condition and add them to a data structure.
%
%
%

%clusters to be averged
cluster=[4];
%time ranges
lat1=[0];
lat2=[999];
%freqs
freq1=[3];
freq2=[5];
Q=22;
%strcture creation
timerange={};
freqrange={};
compoutentstruct = struct;
%add subjects
for c=1:length(cluster)
for k=1:Q
    compoutentstruct(c).cluster(k).subject = STUDY.datasetinfo(STUDY.cluster(4).sets(1,k)).subject;
end
end
%get clostest possible freq and times from data
for c=1:length(cluster)
    abslats=STUDY.cluster(cluster(c)).ersptimes;
    absfreqs=STUDY.cluster(cluster(c)).erspfreqs;
    for t=1:1
    [dist1,latpt1]=min(abs(abslats-lat1(t)));
    [dist2,latpt2]=min(abs(abslats-lat2(t)));
    timerange=[timerange,latpt1,latpt2];
    end
    for f=1:1
    [dist1,freqpt1]=min(abs(absfreqs-freq1(f)));
    [dist2,freqpt2]=min(abs(absfreqs-freq2(f)));
    freqrange=[freqrange,freqpt1,freqpt2];
    end
end
%for all clusters, get average for each category of conditions, time and
%frequency
for c=1:length(cluster)
%Phish/Equivalence
for k=1:Q
        x=1;
    for i=1:1
        z=1;
        y=1;
      for f=1:1
          [R,C] = size(STUDY.cluster(cluster(c)).erspdata{1,1}(:,:,k));
          min_dim = min(R,C);
          n = randi(min_dim-1);
          freq1 = cell2mat(freqrange(y));
          freq2 = cell2mat(freqrange(y+1));
          time1 = cell2mat(timerange(x));
          time2 = cell2mat(timerange(x+1));
          M = STUDY.cluster(cluster(c)).erspdata{1,1}(freq1:freq2,time1:time2,k);
          output = mean(M,1);
          output2 = mean(output);
          y=y+1;
          if f==1 
            compoutentstruct(c).cluster(k).phishE = output2;
          elseif f==2
            compoutentstruct(c).cluster(k).phishE = output2;
          elseif f==3
            compoutentstruct(c).cluster(k).phishE = output2;
          elseif f==4 
            compoutentstruct(c).cluster(k).phishE= output2;
          elseif f==5
            compoutentstruct(c).cluster(k).phishE = output2;
          end
        z=z+1;
      end
      x=x+2;
    end
end
%Spam/Equivalence 
for k=1:Q
        x=1;
    for i=1:1
        z=1;
        y=1;
      for f=1:1
          [R,C] = size(STUDY.cluster(cluster(c)).erspdata{1,2}(:,:,k));
          min_dim = min(R,C);
          n = randi(min_dim-1);
          freq1 = cell2mat(freqrange(y));
          freq2 = cell2mat(freqrange(y+1));
          time1 = cell2mat(timerange(x));
          time2 = cell2mat(timerange(x+1));
          M = STUDY.cluster(cluster(c)).erspdata{1,2}(freq1:freq2,time1:time2,k);
          output = mean(M,1);
          output2 = mean(output);
          y=y+1;
          if f==1 
            compoutentstruct(c).cluster(k).spamE = output2;
          elseif f==2
            compoutentstruct(c).cluster(k).spamE = output2;
          elseif f==3
            compoutentstruct(c).cluster(k).spamE = output2;
          elseif f==4 
            compoutentstruct(c).cluster(k).spamE = output2;
          elseif f==5
            compoutentstruct(c).cluster(k).spamE = output2;
          end
        z=z+1;
      end
      x=x+2;
    end
end
%Phish/Gain
for k=1:Q
        x=1;
    for i=1:1
        z=1;
        y=1;
      for f=1:1
          [R,C] = size(STUDY.cluster(cluster(c)).erspdata{2,1}(:,:,k));
          min_dim = min(R,C);
          n = randi(min_dim-1);
          freq1 = cell2mat(freqrange(y));
          freq2 = cell2mat(freqrange(y+1));
          time1 = cell2mat(timerange(x));
          time2 = cell2mat(timerange(x+1));
          M = STUDY.cluster(cluster(c)).erspdata{2,1}(freq1:freq2,time1:time2,k);
          output = mean(M,1);
          output2 = mean(output);
          y=y+1;
          if f==1 
            compoutentstruct(c).cluster(k).phishG= output2;
          elseif f==2
            compoutentstruct(c).cluster(k).phishG = output2;
          elseif f==3
            compoutentstruct(c).cluster(k).phishG = output2;
          elseif f==4 
            compoutentstruct(c).cluster(k).phishG = output2;
          elseif f==5
            compoutentstruct(c).cluster(k).phishG = output2;
          end
        z=z+1;
      end
      x=x+2;
    end
end
%Spam/Gain 
for k=1:Q
        x=1;
    for i=1:1
        z=1;
        y=1;
      for f=1:1
          [R,C] = size(STUDY.cluster(cluster(c)).erspdata{2,2}(:,:,k));
          min_dim = min(R,C);
          n = randi(min_dim-1);
          freq1 = cell2mat(freqrange(y));
          freq2 = cell2mat(freqrange(y+1));
          time1 = cell2mat(timerange(x));
          time2 = cell2mat(timerange(x+1));
          M = STUDY.cluster(cluster(c)).erspdata{2,2}(freq1:freq2,time1:time2,k);
          output = mean(M,1);
          output2 = mean(output);
          y=y+1;
          if f==1 
            compoutentstruct(c).cluster(k).spamG = output2;
          elseif f==2
            compoutentstruct(c).cluster(k).spamG = output2;
          elseif f==3
            compoutentstruct(c).cluster(k).spamG = output2;
          elseif f==4 
            compoutentstruct(c).cluster(k).spamG = output2;
          elseif f==5
            compoutentstruct(c).cluster(k).spamG = output2;
          end
        z=z+1;
      end
      x=x+2;
    end
end
%Phish/Loss
for k=1:Q
        x=1;
    for i=1:1
        z=1;
        y=1;
      for f=1:1
          [R,C] = size(STUDY.cluster(cluster(c)).erspdata{2,1}(:,:,k));
          min_dim = min(R,C);
          n = randi(min_dim-1);
          freq1 = cell2mat(freqrange(y));
          freq2 = cell2mat(freqrange(y+1));
          time1 = cell2mat(timerange(x));
          time2 = cell2mat(timerange(x+1));
          M = STUDY.cluster(cluster(c)).erspdata{3,1}(freq1:freq2,time1:time2,k);
          output = mean(M,1);
          output2 = mean(output);
          y=y+1;
          if f==1 
            compoutentstruct(c).cluster(k).phishL= output2;
          elseif f==2
            compoutentstruct(c).cluster(k).phishL = output2;
          elseif f==3
            compoutentstruct(c).cluster(k).phishL = output2;
          elseif f==4 
            compoutentstruct(c).cluster(k).phishL = output2;
          elseif f==5
            compoutentstruct(c).cluster(k).phishL = output2;
          end
        z=z+1;
      end
      x=x+2;
    end
end

%Spam/Gain
for k=1:Q
        x=1;
    for i=1:1
        z=1;
        y=1;
      for f=1:1
          [R,C] = size(STUDY.cluster(cluster(c)).erspdata{2,2}(:,:,k));
          min_dim = min(R,C);
          n = randi(min_dim-1);
          freq1 = cell2mat(freqrange(y));
          freq2 = cell2mat(freqrange(y+1));
          time1 = cell2mat(timerange(x));
          time2 = cell2mat(timerange(x+1));
          M = STUDY.cluster(cluster(c)).erspdata{3,2}(freq1:freq2,time1:time2,k);
          output = mean(M,1);
          output2 = mean(output);
          y=y+1;
          if f==1 
            compoutentstruct(c).cluster(k).spamL = output2;
          elseif f==2
            compoutentstruct(c).cluster(k).spamL = output2;
          elseif f==3
            compoutentstruct(c).cluster(k).spamL = output2;
          elseif f==4 
            compoutentstruct(c).cluster(k).spamL = output2;
          elseif f==5
            compoutentstruct(c).cluster(k).spamL = output2;
          end
        z=z+1;
      end
      x=x+2;
    end
end
end