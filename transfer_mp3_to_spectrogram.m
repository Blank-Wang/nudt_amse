clear all
clc
close all
path_mp3 = '.\whale_sound_mp3_JASA\';
path_img = '.\whale_sound_img_JASA\';
creat_img_folder = ['mkdir ',path_img];
system(creat_img_folder);
ext = '.mp3';
Ft=20000;
%read class name and number of classes
myfolder = dir(path_mp3);
class = length(ls(path_mp3))-2;
class_id_list = zeros(class,1);

for ii = 3:class+2
    class_id_list(ii-2) = str2num(myfolder(ii).name);
end
for i = 1:class
    class_id=num2str(class_id_list(i));
    number_of_file = length(ls(strcat(path_mp3,class_id)))-2;
    dirname = [path_img,class_id];
    s = ['mkdir ',dirname];
    system(s);
    for CL = 1 : number_of_file
        file_num = num2str(CL);
        [O,FS]=audioread(strcat(path_mp3,class_id,'\',file_num,ext));          %read data
        S=resample(O,Ft,FS);                                                      %resample signal to 2KHZ
        MP3_to_STFT(strcat(path_img,class_id),S,Ft,file_num);
    end
end