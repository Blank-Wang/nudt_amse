clear all
clc
close all
path_initial_folder = '.\class16\';
path_augment_folder = '.\whale_sound_img_JASA_augment16\';
augment_info = dir(path_augment_folder);
augment_num = length(ls(path_augment_folder))-2;
augment_id_list = zeros(augment_num,1);
for ii = 3:augment_num+2
   augment_id_list(ii-2) = str2num(augment_info(ii).name);
end

for i =1 : augment_num
    augment_deal = num2str(augment_id_list(i));
    path_initial_folder_deal = strcat(path_initial_folder,augment_deal,'\');
    path_augment_folder_deal = strcat(path_augment_folder,augment_deal,'\');
    ext = '*.tif';
    p_a = dir([path_augment_folder_deal,ext]);
    p_a_name = {p_a.name};
    p_a_length = length(p_a);
    for j = 1:p_a_length
        copyfile([path_augment_folder_deal,p_a_name{j}],[path_initial_folder_deal,p_a_name{j}]);
    end
end
    
    