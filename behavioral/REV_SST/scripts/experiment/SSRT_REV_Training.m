%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Stopfmri %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Adam Aron 12-01-2005
%%% Adapted for OSX Psychtoolbox by Jessica Cohen 12/2005
%%% Modified for use with new BMC trigger-same device as button box by JC 1/07
%%% Sound updated and modified for Jess' dissertation by JC 10/08
%%% Two SSTs interspersed for individualized risk categories by LEK 12/2014
% updated 1-8-15 to standardize area instead of height
% updated 2-9-15 to adjust numbering for images (out of 1772)
% updated 3-4-15 to add sub-specific output folders within train folder
% updated 3-24-15 to remove the sound in order to make this control
% condition specific; also fixed output folder location (line 177)

cd('~/Desktop/REV_SST/output/train')
clear all;
% output version
script_name='Stopfmri: optimized SSD tracker for fMRI';
script_version='1';
revision_date='3-4-15';
prefix = 'REV'

notes={'Design developed by Aron, Newman and Poldrack, based on Aron et al. 2003'};

%Set params
standardImHeight=200;
standardImArea=standardImHeight*standardImHeight;
oval2imRatio=2;
chunkSize = [14 28]; %7 or 14 trials
trialsPerStimType=126;
riskStimListFile='stimFile_PRC_1772.txt';
neutStimListFile='stimFile_Neutral_1772.txt';
stimFolder = 'Training';

% read in subject initials
fprintf('%s %s (revised %s)\n',script_name,script_version, revision_date);
subject_code=input('Enter subject number (integer only): ');
sub_session=input('What training session is this? (Enter a number 1 through 10): ');
exptCond=input('Which condition? (Enter a 1 or 0): ');
% MRI=input('Are you scanning? 1 if yes, 0 if no: ');
MRI = 0;
cumulativeSessNum = sub_session+2;

startImage = 256 + (sub_session-1)*126+1
endImage =  256 + (sub_session)*126
imIndices = startImage:endImage;

if subject_code<10
    placeholder = '00';
elseif subject_code<100
    placeholder = '0';
else
    placeholder = '';
end

mkdir([prefix placeholder num2str(subject_code)])
cd([prefix placeholder num2str(subject_code)])


% Color Flags!
% At the end of each trial, the script will check whether the RT was > the
% highThresh or the lowThresh.
% If it's over the highThresh, it'll make the following cue be outlined in
% red.
% If it's over the lowThresh (but not the highThresh) it'll be outlined in
% orange.
% This is important for keeping RTs within range, keeping the adjusting algorithm
% working properly, but you have to explain it to participants (of course!)
colorFlags=1; % Can turn off color flags by setting colorFlags to 0
FLAG_FASTER=0;

%read in tab delimited file set up like MacStim (textread will read in as
%col vectors)
% [type,num,pre,maxTime,totTime,rep,stpEvt,bg,st,bgFile,stFile,hshift,vshift,tag]= textread(tdfile, '%c %d %f %f %f %d %s %c %c %s %s %d %d %s','delimiter', '\t', 'whitespace', '', 'commentstyle', 'matlab' );

%These used to be called stFile1 and stFile2, or just stFile.
[riskStim] = textread(riskStimListFile, '%s','delimiter', '\t', 'whitespace', '', 'commentstyle', 'matlab' );
[neutStim] = textread(neutStimListFile, '%s','delimiter', '\t', 'whitespace', '', 'commentstyle', 'matlab' );
riskStim = riskStim(imIndices);
neutStim = neutStim(imIndices);

indices = [1:length(riskStim)];
indices = indices';
rng('default')
rng('shuffle')
% shuffNeutInd = Shuffle(indices);
shuffNeutInd = randperm(length(riskStim));
rng('shuffle')
% shuffRiskInd = Shuffle(indices);
shuffRiskInd = randperm(length(neutStim));

riskStim=riskStim(shuffRiskInd);
neutStim=neutStim(shuffNeutInd);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if sub_session==1,
    Ladder=cell(1,2);
    Ladder1=cell(1,2);
    Ladder2=cell(1,2);
    
    LADDER1IN=250 %input('Ladder1 start val (e.g. 250): ');
    LADDER2IN=350 %input('Ladder2 start val (e.g. 350): ');
    
    %Ladder Starts (in ms):
    for type = 1:2
        Ladder1{type}=LADDER1IN;
        Ladder2{type}=LADDER2IN;
        
        Ladder{type}(1,1)=LADDER1IN;
        Ladder{type}(2,1)=LADDER2IN;
    end
    
elseif sub_session>1, %% this code looks up the last value in each staircase
    sub_session_temp=sub_session;
    trackfile=input('Enter name of subject''s previous ''mat'' file to open: ','s');
    load(trackfile);
    clear Seeker; %gets rid of this so it won't interfere with current Seeker
    
    for type = 1:2
        startval(type)=length(Ladder1{type});
        Ladder{type}(1,1)=Ladder1{type}(startval(type));
        startval(type)=length(Ladder2{type});
        Ladder{type}(2,1)=Ladder2{type}(startval(type));
    end
    sub_session = sub_session_temp
end;

%load relevant input file for scan (there MUST be st1b1.mat & st1b2.mat)
inputfile=sprintf('dub_st%db%d.mat',subject_code,sub_session);
load(inputfile); % variable is trialcode, a cell array with a cell for each stim type

% write trial-by-trial data to a text logfile
d=clock;
logfile=sprintf('sub%d_scan%d_stopsig.log',subject_code,sub_session);
fprintf('A log of this session will be saved to %s\n',logfile);
fid=fopen(logfile,'a');
if fid<1,
    error('could not open logfile!');
end;

fprintf(fid,'Started: %s %2.0f:%02.0f\n',date,d(4),d(5));
WaitSecs(1);

%Seed random number generator
rand('state',subject_code);

try,  % goes with catch at end of script
    
    %% set up INPUT DEVICES
    [inputDevice] = setUpDevices(MRI); % FUNCTION CREATED BY LEK 12/20/14
    
    % set up SCREENS
    Screen('Preference', 'SkipSyncTests', 1);
    [w ArrowSize ArrowPosX ArrowPosY xcenter ycenter] = setUpScreens();
    
    cd(['~/Desktop/REV_SST/subjects/' prefix placeholder num2str(subject_code) '/Images/' stimFolder])
    %Preload riskStim
    imagetex = cell(1,2);
    imagetex{1} = zeros(1,length(riskStim)); %initialize imagetex for pics
    for i=1:trialsPerStimType
        riskStim{i}
        img = imread(riskStim{i});
        itex = Screen('MakeTexture', w, img);
        imagetex{1}(i) = itex;
    end
    
    %Preload neutStim
    imagetex{2} = zeros(1,length(neutStim)); %initialize imagetex for pics
    for i=1:trialsPerStimType; %tc=256 and is all events, not just trials
        neutStim{i}
        img = imread(neutStim{i});
        itex = Screen('MakeTexture', w, img);
        imagetex{2}(i) = itex;
    end
    
cd('~/Desktop/REV_SST/output/train')
cd([prefix placeholder num2str(subject_code)])
    
    %Adaptable Constants
    % "chunks", will always be size 64:
    NUMCHUNKS=4;  %gngscan has 4 blocks of 64 (2 scans with 2 blocks of 64 each--but says 128 b/c of interspersed null events)
    Step=50;
    ISI=1.5; %set at 1.5
    BSI=1 ;  %NB, see figure in GNG4manual (set at 1 for scan)
    arrow_duration=1; %because stim duration is 1.5 secs in opt_stop
    
    %%% FEEDBACK VARIABLES
    if MRI==1,
        %trigger = KbName('t');
        trigger = [52];
        blue = KbName('b');
        yellow = KbName('y');
        green = KbName('g');
        red = KbName('r');
        %LEFT=[98 5 10];   %blue (5) green (10)
        LEFT = [91];
        RIGHT=[94];
        %RIGHT=[121 28 21]; %yellow (28) red (21)
    else,
        LEFT=[197];  %<
        RIGHT=[198]; %>
    end;
    
    if sub_session==1;
        error=zeros(1, NUMCHUNKS/2);
        rt = zeros(1, NUMCHUNKS/2);
        count_rt = zeros(1, NUMCHUNKS/2);
    end;
    
    %%%% Setting up the sound stuff
    [wave pahandle] = configSound();
    
    %%%%%%%%%%%%%% Stimuli and Response on same matrix, pre-determined
    % The first column is trial number;
    % The second column is numchunks number (1-NUMCHUNKS);
    % The third column is 0 = Go, 1 = NoGo; 2 is null, 3 is notrial (kluge, see opt_stop.m)
    % The fourth column is 0=left, 1=right arrow; 2 is null
    % The fifth column is ladder number (1-2);
    % The sixth column is the value currently in "LadderX", corresponding to SSD
    % The seventh column is subject response (no response is 0);
    % The eighth column is ladder movement (-1 for down, +1 for up, 0 for N/A)
    % The ninth column is their reaction time (sec)
    % The tenth column is their actual SSD (for error-check)
    % The 11th column is their actual SSD plus time taken to run the command
    % The 12th column is absolute time since beginning of task that trial begins
    % The 13th column is the time elapsed since the beginning of the block at moment when arrows are shown
    % The 14th column is the actual SSD for error check (time from arrow displayed to beep played)
    % The 15th column is the duration of the trial from trialcode
    % The 16th column is the time_course from trialcode
    
    %this puts trialcode into Seeker
    % trialcode was generated in opt_stop and is balanced for 4 staircase types every 16 trials, and arrow direction
    %  see opt_stop.m in /gng/optmize/stopping/
    % because of interdigitated null and true trial, there will thus be four staircases per 32 trials in trialcode
    
    Seeker = cell(1,2);
    for stimType = 1:2
        for  tc=1:252,                         %go/nogo        arrow dir       staircase    initial staircase value                    duration       timecourse
            if trialcode{stimType}(tc,5)>0, % if it's a stop trial then put in the initial ladder val; else don't
                Seeker{stimType}(tc,:) = [tc sub_session  trialcode{stimType}(tc,1) trialcode{stimType}(tc,4) trialcode{stimType}(tc,5) Ladder{stimType}(trialcode{stimType}(tc,5)) 0 0 0 0 0 0 0 0 trialcode{stimType}(tc,2) trialcode{stimType}(tc,3)];
            else,
                Seeker{stimType}(tc,:) = [tc sub_session trialcode{stimType}(tc,1) trialcode{stimType}(tc,4) trialcode{stimType}(tc,5) 0 0 0 0 0 0 0 0 0 trialcode{stimType}(tc,2) trialcode{stimType}(tc,3)];
            end;
        end;
    end;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%% TRIAL PREP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % FUNCTION CREATED BY LEK 12/20/14
    Screen('Preference', 'SkipSyncTests', 0)
    displayPrepScreens(exptCond,sub_session,w,MRI,xcenter,ycenter);
    
    if MRI==1,
        secs=KbTriggerWait(trigger,inputDevice);
        %secs = KbTriggerWait(KbName('t'),controlDevice);
    else, % If using the keyboard, allow any key as input
        noresp=1;
        while noresp,
            [keyIsDown,secs,keyCode] = KbCheck(inputDevice);
            if keyIsDown & noresp,
                noresp=0;
            end;
        end;
        WaitSecs(0.001);
    end;
    % WaitSecs(0.5);  % prevent key spillover--ONLY FOR BEHAV VERSION
    
    if MRI==1
        DisableKeysForKbCheck(trigger); % So trigger is no longer detected
    end
    
    %%% TRIAL PRESENTATION:
    %%% LEK vsn with interspersed trials
    
    %initialize counter vars
    anchor=GetSecs;
    t(1:2)=1;
    tc(1:2)=1;
    block(1:2)=1;
    a(1:2)=1;
    riskOrNeut=[ones(1,trialsPerStimType) zeros(1,trialsPerStimType)];
    riskOrNeut=Shuffle(riskOrNeut);%risk = 1, neut = 0
    
    allStimOrder = cell(length(riskStim)+length(neutStim),1);
    allStimOrder(logical(riskOrNeut)) = riskStim;
    allStimOrder(~logical(riskOrNeut)) = neutStim;
    save(['stimOrderLog_st' num2str(subject_code) 'b' num2str(sub_session) '.mat'],'allStimOrder')
    fd=fopen(['stimOrderLog_st' num2str(subject_code) 'b' num2str(sub_session) '.txt'],'a');
    for l=1:size(allStimOrder,1)
        fprintf(fd,'%s\n',allStimOrder{l});
    end
    fclose(fd);
    
    for i=1:length(riskOrNeut)
        if riskOrNeut(i)==1
            type=1; %risk
        else type=2; %neut
        end
        
        %%%%%%%% FUNCTION CREATED BY LEK 12/20/14 %%%%%%%%
        [tc t a block Seeker Ladder1 Ladder2 Ladder FLAG_FASTER] = presentTrial(exptCond,colorFlags,FLAG_FASTER,type,tc,t,a,block,Seeker,imagetex,inputDevice,anchor,w,Step,Ladder1,Ladder2,Ladder,oval2imRatio,standardImHeight,standardImArea,ArrowSize,ArrowPosX,ArrowPosY,arrow_duration,MRI,pahandle,wave,fid,chunkSize);
        
    end
    
    % Close the audio device:
    PsychPortAudio('Close', pahandle);
    %try,   %dummy try if need to troubleshoot
catch,    % (goes with try, line 61)
    rethrow(lasterror);
    Screen('CloseAll');
    ShowCursor;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SAVE DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=clock;
outfile=sprintf('sub%d_run%d_train%d_%s_%02.0f-%02.0f.mat',subject_code,cumulativeSessNum,sub_session,date,d(4),d(5));
Snd('Close');

combinedSeeker = vertcat(Seeker{1},Seeker{2});
combinedSeeker = sortrows(combinedSeeker,16);

try,
    save(outfile, 'Seeker', 'Ladder1', 'Ladder2', 'subject_code', 'sub_session','combinedSeeker');
catch,
    fprintf('couldn''t save %s\n saving to stopsig_fmri.mat\n',outfile);
    save stopsig_fmri;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WaitSecs(3);
Screen('TextSize',w,36);
Screen('TextFont',w,'Ariel');
Screen('DrawText',w,'Great Job. Thank you!',xcenter-200,ycenter);
Screen('Flip',w);
WaitSecs(1);
Screen('Flip',w);
Screen('CloseAll');
ShowCursor;