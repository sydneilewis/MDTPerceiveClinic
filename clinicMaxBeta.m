%QUESTIONS: Dr. T, if your script shows mag v freq, why are we doing 
%spectrum to view in frequency domain? Aren't we there? 
%ask about offset time, aka why is it 3pm? %who knows! 
%      it is six hours 
%why is this only occuring on stim right, body left? will it always be 
%directional? why? 
%      assess stim on specifiic hemi, without spillage from other side 
%      need clean signal, hard with two stim sources
%      compare original w novel based on beta peak

%pwr in db is similar is mV like other one, db is similar enough
%electrode is showing oscillating voltage, freq also oscillates 
%power is output from transform fast fourier transform
%tells us magnitude at each frequency, we care about beta, bc science

%rancket paper, keeping power the same as clinical bench mark  

%NEXT STEPS 
%create input argument for one or two batteries? 
%create stacked plot for the freq v pwr to show both sides

%% loads in json file 
%started test 1 at 934
cd('C:\Users\sydne\Documents\MATLAB\ThompsonLab')
%initDir = dir('*.json');
%whats this file? 
%FILE ENDING IN 4200 is brainsense normal no condiditions
jsonFiles = 'Report_Json_Session_Report_20210604T094200.json';

js = jsondecode(fileread(jsonFiles)); 

%% using function to compare specific trials 
%close;
%numbers should be six apart spanning the trials 
figure;
nonAvgTrialCompare(leng, js, 1, 13, 13+12) 
xlabel("Frequency (Hz)")
ylabel("Power Spectrum (dB)")
legend("1", "13", "25") 

figure;
nonAvgTrialCompare(leng, js, 8, 20, 32) 
xlabel("Frequency (Hz)")
ylabel("Power Spectrum (dB)")
legend("8", "20", "32")
%% 
%Generates differences between trials
testtime = {js.LfpMontageTimeDomain.FirstPacketDateTime};
cleantime = {}; %initialize new cell array for clean times
leng = numel(testtime); %have to use numel here bc length sucks? 
for i = 1:leng
    bettertime = replace(testtime{i}, {'T', 'Z'},  {' ', ''}); 
    cleantime{i} = datetime(bettertime) - hours(6); %converts string to datetime
    %fix by moving the time back six hours to make it correct 
end

%now find differentials between the times 
diff = {}; %q is this still a cell array?? 
for i = 1:(leng-1)
    diff{i} = cleantime{i+1} - cleantime{i};
end
%the first entry is the difference between cells 2 and 1, 
%second entry is diff between 3 and 2, etc 

%% run to get full graph
%{} gets the thing from the actual cell array
%() gets cell ARRAY! 

%troubleshooting 
%is length is expected?
%is channels the same as lfpMontageTimeDomain.Channel? 
%is starting place expected? 
close
sides = {'LEFT', 'RIGHT'};
for  i = 1:2 
leng = numel({js.LfpMontageTimeDomain.Channel});
channels = unique({js.LfpMontageTimeDomain.Channel}); 
channels2 = channels(contains(channels,sides{i}));


colors = 'krbgmc';
maxValues = zeros(length(channels2), 1);
for c=1:length(channels2)
    maxValues(c) = tempAvgPlot(1, leng, js, channels2{c}, colors(c))
    hold on; 
end 
[M, I] = max(maxValues); 
highestBeta = channels2{I};

%add all the plot info 

xline(13)
xline(30)

%these are the order presented in channels

legendChan = {};
for i = 1:length(channels) 
    legendChan{i} = replace(channels{i}, '_', ' ');
end 

%legend(legendChan{1}, legendChan{2}, legendChan{3}, legendChan{4}, legendChan{5}, legendChan{6}, "Beta lb", "Beta ub")
legend("03", "13", "02", "01", "12", "23")
title("Freq vs. Power (db)")
xlabel("Frequency")
ylabel("Power") 

disp(['The highest beta comes from ', highestBeta])
end 
figure; 
%% Direct compare two contact pairs 
close; 
channelA = channels{2}; 
channelB = channels{5};
directCompare(7, leng, js, channelA, channelB)

xline(13)
xline(30)
%these are the order presented in channels
legend(channelA, channelB, "Beta lb", "Beta ub")
title("Freq vs. Power (db)")
xlabel("Frequency")
ylabel("Power") 
