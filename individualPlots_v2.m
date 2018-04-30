%Visualizations (subplots) for Arrest Paper
% Maansi Desai, Garret Kurteff, Alia Shafi - April, 2018

% 1. Plotting errors per patient, showing duration of errors centered
% around stimulation per trial
% 2. Plotting all error types and timing info in relation to stim
% 3. Plotting all regions and error types with timing info in relation to
% stim

%You will need individualPlotTimes_patient.xlsx,
%individualPlotTimes_region.xlsx, individualPlotTimes_error.xlsx OR combine
%info in all of these spreadsheets and alter the codes for columns

% RUN THIS SCRIPT CELL BY CELL!


%% Create graphs for each patient showing error (type of?? st. dev??) per trial across time with stimulation occuring at the origin

clear all
close all


addpath(genpath('/Users/maansi/Desktop/Arrest_data/'))
rootdir = '/Users/maansi/Desktop/Arrest_data/SpeechArrestData';

cd(rootdir)

%set up cell array with patient ID numbers
patient_IDs = {'103','106','119','132','133', '142', '143', '147', '152', '155', '159', '170', '70x', '179', 'A18', '189', '208', '223', '232', '235', '268', '289', '295', '304', '31a', '321', 'A35', 'A38', 'A41', 'A63', 'A71', 'A75', 'A83', 'A86'}';

% read into excel file
filename = 'individualPlotTimes_patient.xlsx';
[num,txt,raw] = xlsread(filename);

%extract values 
patientPlotsheet = raw(:,2);
tbon = num(:,4);
tboff = num(:,5);
oboff = num(:,6);
obon = num(:,7);
son = num(:,8);
soff = num(:,9);
oaon = num(:,10);
oaoff = num(:,11);

%create structure
StimTimes = struct;
Patient_Data = cell(numel(patient_IDs),1);


for i=1:length(patient_IDs)
    Index = [];
    for j=1:numel(patientPlotsheet)
        if strcmp((patient_IDs{i}), num2str(patientPlotsheet{j}));
            Index = [Index, j];  
        end
    end
    
    %Put timing data in defined structure based on patient ID
    Patient_Data{i} =  num(Index,4:11);
    
    StimTimes(i).tbon = tbon(Index,:);
    StimTimes(i).tboff = tboff(Index,:);
    StimTimes(i).oboff = oboff(Index,:);
    StimTimes(i).obon = obon(Index,:);
    StimTimes(i).son = son(Index,:);
    StimTimes(i).soff = soff(Index,:);
    StimTimes(i).oaon = oaon(Index,:);
    StimTimes(i).oaoff = oaoff(Index,:);
    StimTimes(i).PatientID = patient_IDs{i};
end
%% Generate Subplot per patient 

figure
for i=1:34
    h = subplot(6,6,i);
    hold on
    y_val = [1:size(StimTimes(i).tboff,1)];

    ii = [StimTimes(i).tboff,StimTimes(i).tbon,y_val'];        
    for k = 1:size(ii,1)

        % tboff vs. tbon
        ii = [StimTimes(i).tboff,StimTimes(i).tbon,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','r','MarkerEdgeColor','r')
        %oboff vs. obon
        ii = [StimTimes(i).oboff,StimTimes(i).obon,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','g','MarkerEdgeColor','g')
        %soff vs. son
        ii = [StimTimes(i).soff,StimTimes(i).son,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','b','MarkerEdgeColor','b')
        %oaoff vs. oaon
        ii = [StimTimes(i).oaoff,StimTimes(i).oaon,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','m','MarkerEdgeColor','m')

        % add origin line and set axis 
        Y_li= get(gca,'Ylim');
        X_li = get(gca,'Xlim');
        plot([0 0], Y_li,'k','linewidth',1)
        set(gca,'Ylim',[y_val(1)-0.5 y_val(end)+0.5])
        xlim([-10 10])
        %set(gca, 'Xlim') 

    end

    %title per patient per subplot
    title(patient_IDs{i})

end
    
%Set x and y labels along with legend and title for subplot    
hY=text(-100,50,'Trial','rotation',90,'fontsize',18,'horizontalalignment','center','verticalalignment','bottom');
hX=text(-15,-5,'Response Time (s)','rotation',0,'fontsize',18,'horizontalalignment','center','verticalalignment','top');
hgL = legend({'Two Trials Before Stim', 'Trial before Stim', 'Two trials after Stim', 'Trial after Stim'}, 'FontSize',10,'FontWeight','bold', 'Position', [0.525,0.10,0.40,0.1]);
suptitle('Subplots by Individual Patients')

%% By error type

clear all 

%set up cell array with error names 
error_IDs = {'motor', 'word', 'syllable', 'number'};

%read into excel 
filename = 'individualPlotTimes_error.xlsx';
[num,txt,raw] = xlsread(filename);

%sort values according to "son"
[ranks_ordered, idx] = sort(cell2mat(raw(:,8)));
raw = raw(idx,:);

%extract values 
errorPlotsheet = raw(:,3);
tbon = cell2mat(raw(:,4));
tboff = cell2mat(raw(:,5));
oboff = cell2mat(raw(:,6));
obon = cell2mat(raw(:,7));
son = cell2mat(raw(:,8));
soff = cell2mat(raw(:,9));
oaon = cell2mat(raw(:,10));
oaoff = cell2mat(raw(:,11));

%create structure
StimTimes = struct;
Error_Data = cell(numel(error_IDs),1);

for i=1:length(error_IDs)
    Index = [];
    for j=1:numel(errorPlotsheet)
        if strcmpi((error_IDs{i}), num2str(errorPlotsheet{j}));
           Index = [Index, j];  
        end
    end
    
    %Put timing data in defined structure based on error categorization 
    Error_Data{i} =  num(Index,4:11);
    
    StimTimes(i).tbon = tbon(Index,:);
    StimTimes(i).tboff = tboff(Index,:);
    StimTimes(i).oboff = oboff(Index,:);
    StimTimes(i).obon = obon(Index,:);
    StimTimes(i).son = son(Index,:);
    StimTimes(i).soff = soff(Index,:);
    StimTimes(i).oaon = oaon(Index,:);
    StimTimes(i).oaoff = oaoff(Index,:);
    StimTimes(i).ErrorID = error_IDs{i};
end

%% Generate subplot based on error categorization 

figure
for i=1:4
    h = subplot(2,2,i);
    hold on
    y_val = [1:size(StimTimes(i).tboff,1)];

    ii = [StimTimes(i).tboff,StimTimes(i).tbon,y_val'];        
    for k = 1:size(ii,1)

        % tboff vs. tbon
        ii = [StimTimes(i).tboff,StimTimes(i).tbon,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','r','MarkerEdgeColor','r')
        %oboff vs. obon
        ii = [StimTimes(i).oboff,StimTimes(i).obon,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','g','MarkerEdgeColor','g')
        %soff vs. son
        ii = [StimTimes(i).soff,StimTimes(i).son,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','b','MarkerEdgeColor','b')
        %oaoff vs. oaon
        ii = [StimTimes(i).oaoff,StimTimes(i).oaon,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','m','MarkerEdgeColor','m')

        % add origin line and set axis 
        Y_li= get(gca,'Ylim');
        X_li = get(gca,'Xlim');
        plot([0 0], Y_li,'k','linewidth',1)
        set(gca,'Ylim',[y_val(1)-0.5 y_val(end)+0.5])
        xlim([-10 10])
        %set(gca, 'Xlim') 

    end

    %title per patient per subplot
    title(error_IDs{i})

end

%Set x and y labels along with legend and title for subplot
hY=text(-40,9,'Trial','rotation',90,'fontsize',18,'horizontalalignment','center','verticalalignment','bottom');
hX=text(-14,-1,'Response Time (s)','rotation',0,'fontsize',18,'horizontalalignment','center','verticalalignment','top');
hgL = legend({'Two Trials Before Stim', 'Trial before Stim', 'Two trials after Stim', 'Trial after Stim'}, 'FontSize',10,'FontWeight','bold', 'Position', [0.525,0.05,0.30,0]);
suptitle('Subplots by Error Type')

%% plot individual patient by brain region 

clear all 

%set up cell array with error names 
region_IDs = {'ifg', 'dorsal', 'ventral', 'other'};

%read into excel 
filename = 'individualPlotTimes_region.xlsx';
[num,txt,raw] = xlsread(filename);

%sort values according to "son"
[ranks_ordered, idx] = sort(cell2mat(raw(:,9)));
raw = raw(idx,:);

%extract values 
regionPlotsheet = raw(:,4);
tbon = cell2mat(raw(:,5));
tboff = cell2mat(raw(:,6));
oboff = cell2mat(raw(:,7));
obon = cell2mat(raw(:,8));
son = cell2mat(raw(:,9));
soff = cell2mat(raw(:,10));
oaon = cell2mat(raw(:,11));
oaoff = cell2mat(raw(:,12));

%create structure
StimTimes = struct;
Region_Data = cell(numel(region_IDs),1);

for i=1:length(region_IDs)
    Index = [];
    for j=1:numel(regionPlotsheet)
        if strcmpi((region_IDs{i}), num2str(regionPlotsheet{j}));
           Index = [Index, j];  
        end
    end
    
    %Put timing data in defined structure based on error categorization 
    Region_Data{i} =  num(Index,4:11);
    
    StimTimes(i).tbon = tbon(Index,:);
    StimTimes(i).tboff = tboff(Index,:);
    StimTimes(i).oboff = oboff(Index,:);
    StimTimes(i).obon = obon(Index,:);
    StimTimes(i).son = son(Index,:);
    StimTimes(i).soff = soff(Index,:);
    StimTimes(i).oaon = oaon(Index,:);
    StimTimes(i).oaoff = oaoff(Index,:);
    StimTimes(i).RegionID = region_IDs{i};
end

%% Generate subplot of stim latency based on brain region

figure
for i=1:4
    h = subplot(2,2,i);
    hold on
    y_val = [1:size(StimTimes(i).tboff,1)];

    ii = [StimTimes(i).tboff,StimTimes(i).tbon,y_val'];        
    for k = 1:size(ii,1)

        % tboff vs. tbon
        ii = [StimTimes(i).tboff,StimTimes(i).tbon,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','r','MarkerEdgeColor','r')
        %oboff vs. obon
        ii = [StimTimes(i).oboff,StimTimes(i).obon,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','g','MarkerEdgeColor','g')
        %soff vs. son
        ii = [StimTimes(i).soff,StimTimes(i).son,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','b','MarkerEdgeColor','b')
        %oaoff vs. oaon
        ii = [StimTimes(i).oaoff,StimTimes(i).oaon,y_val'];
        plot([ii(k,1), ii(k,2)],[ii(k,3), ii(k,3)], 'b-', 'linewidth',2,'color','m','MarkerEdgeColor','m')

        % add origin line and set axis 
        Y_li= get(gca,'Ylim');
        X_li = get(gca,'Xlim');
        plot([0 0], Y_li,'k','linewidth',1)
        set(gca,'Ylim',[y_val(1)-0.5 y_val(end)+0.5])
        xlim([-10 10])
        %set(gca, 'Xlim') 

    end

    %title per patient per subplot
    title(region_IDs{i})

end

%Set x and y labels along with legend and title for subplot
hY=text(-40,9,'Trial','rotation',90,'fontsize',18,'horizontalalignment','center','verticalalignment','bottom');
hX=text(-14,-1,'Response Time (s)','rotation',0,'fontsize',18,'horizontalalignment','center','verticalalignment','top');
hgL = legend({'Two Trials Before Stim', 'Trial before Stim', 'Two trials after Stim', 'Trial after Stim'}, 'FontSize',10,'FontWeight','bold', 'Position', [0.525,0.05,0.30,0]);
suptitle('Subplots by Region')

