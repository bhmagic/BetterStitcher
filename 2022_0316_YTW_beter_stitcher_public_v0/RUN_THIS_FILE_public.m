% Better Stitcher internal v 1.1,  
% An improved version of the wably stitcher done by YTW in YK lab

clear
close all

% Basic setting
Sorce_folder = 'E:\20220210_10_03_26_SM_SM206_F_p120_561Tdtomato_639BG_4x_5umstep_AAVSynapsinAEPD'; % raw data foldeer containing all image tif files
file_expression = 'E:\20220210_10_03_26_SM_SM206_F_p120_561Tdtomato_639BG_4x_5umstep_AAVSynapsinAEPD\Em_*CCCC*\*XXXX*\*XXXX*_*YYYY*\*ZZZZ*.tiff';

Working_folder = 'E:\testing_w'; % local SSD folder for final output
channel_for_stitching = 1; % 1 meaning first channel (number low to high)

making_shrink_after_stitching = 1; %can only mak shrink if you chosed to make tif above
shrink_ratio = [20, 1];  % [10 1] means 10x downsizing on XY and 1x downsizing on Z



%%% Scope Specific infomation
tiling_info.x_pixel = 2000; %pix
tiling_info.y_pixel = 1600; %pix
tiling_info.x_overlap = 200; %pix
tiling_info.y_overlap = 160; %pix


%%% Wably setting
z_truncate = 200;
shift_allowed = 30;
smooth_index = 8;


%%% Other setting

inverting_x_y = 1; % Just put 1. Putting 0 do not work, this function is still under wokingg
hard_fix_empty_space = 1;

max_cores = 0;


%%% Computation

if max_cores == 0
    max_cores = str2num(getenv('NUMBER_OF_PROCESSORS'));
end
images_folder = Sorce_folder;


file_indexing_v2;

wably_stitcher_re;

shifting_inndex_optimizaer;

stitching_for_real;
