%% The script scavange through subdirectories to find *.avi files and analyze them for the rotation of tehtered cells.
% When the script is runned, a UI selection box appears. Chose the direcotry
% to be analyzed. The output variable "List" records all of the analyzed
% files. If it shows "ERROR IN ANALYSIS", the file was not analyzed.


%%
clear all
close all

%%% Detemine N workers available, and assign analysis to N-1 workers
  c = parcluster('local'); % build the 'local' cluster object
  N = c.NumWorkers;        % get the number of workers
  parpool(max([1 N-1]));   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Compress = 0; %% Toggle 0/1 to not produce or to produce a new movie with cropped regions of rotating cells, respectivley.
List = [{'Directory'} {'File'}];
Directory = uigetdir;

List = LookForAviOrRetreat(Directory,List,1,Compress);

