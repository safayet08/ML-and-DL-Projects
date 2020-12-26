clc; clear all; close all;

fis = newfis('Blood Pressure Classifier', 'FISType', 'mamdani');

%-------INPUTTING THE SYSTOLIC PRESSURE
fis.input(1).name = 'Systolic Pressure'; 
fis.input(1).range = [10 250];

% 1st member function
fis.input(1).mf(1).name = 'Normal';
fis.input(1).mf(1).type = 'trimf';
fis.input(1).mf(1).params = [10 110 135];

% 2nd member function
fis.input(1).mf(2).name = 'High';
fis.input(1).mf(2).type = 'trimf';
fis.input(1).mf(2).params = [130 150 250];


%-------INPUTTING THE DIASTOLIC PRESSURE
fis.input(2).name = 'Diastolic Pressure'; 
fis.input(2).range = [10 200];

% 1st member function
fis.input(2).mf(1).name = 'Normal';
fis.input(2).mf(1).type = 'trimf';
fis.input(2).mf(1).params = [10 75 85];

% 2nd member function
fis.input(2).mf(2).name = 'High';
fis.input(2).mf(2).type = 'trimf';
fis.input(2).mf(2).params = [80 100 200];

%--PROCESSING THE OUTPUT
fis.output(1).name = 'Blood Pressure Classification';
fis.output(1).range = [0 100];

fis.output(1).mf(1).name = 'Normal Level';
fis.output(1).mf(1).type = 'trimf';
fis.output(1).mf(1).params = [0 20 40];

fis.output(1).mf(2).name = 'Risk Level';
fis.output(1).mf(2).type = 'trimf';
fis.output(1).mf(2).params = [35 70 100];


%Rule Evaluation

%1.	IF Systolic Pressure is Normal AND  Diastolic Pressure is Normal  THEN
%Output Blood Pressure Level is Normal Level

fis.rule(1).antecedent = [1 1]; 
fis.rule(1).consequent = 1;
fis.rule(1).weight = 1;
fis.rule(1).connection = 1; %1 for AND; 2 for OR

%2.	IF Systolic Pressure is High OR  Diastolic Pressure is High  THEN
%Output Blood Pressure Level is Risk Level

fis.rule(2).antecedent = [2 2];
fis.rule(2).consequent = 2;
fis.rule(2).weight = 1;
fis.rule(2).connection = 2; % OR

%plotmf(fis,'input',1);

%plotmf(fis,'input',2);

%plotmf(fis,'output',1);

%Evaluation of FIS

evalfis([ 120 90],fis) % for single person assessment

round(ans)

ruleview(fis)

[Data]=xlsread('inputs_BP_Classifier','A2:B11');  %importing group data for checking group data
input=Data;

evalfis(input,fis);


round(ans); %for rounding the ans

filename='inputs_BP_Classifier.xlsx'; %exporting group data
xlswrite(filename,ans,1,'D2')

plotfis(fis);