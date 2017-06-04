clear all
clc
close all

path_img= '.\class4\';
path_img_augment = '.\whale_sound_img_JASA_augment4\';
creat_img_augment_folder = ['mkdir ',path_img_augment];
system(creat_img_augment_folder);
img_folder = dir(path_img);
class = length(ls(path_img))-2;
class_id_list = zeros(class,1);
for ii = 3:class+2
   class_id_list(ii-2) = str2num(img_folder(ii).name);
end

ext = '.tif';
new_xn=zeros(256,256,3);
augment_number = 3000;
augment_class = [];
for i = 1:class
    class_id=num2str(class_id_list(i));
    number_of_file = length(ls(strcat(path_img,class_id)))-2;
	if(number_of_file < augment_number)
	augment_class = [augment_class,class_id_list(i)];    
	end
end

for i = 1:length(augment_class)
     class_id=num2str(augment_class(i));
     creat_img_augment_sub_folder = ['mkdir ',strcat(path_img_augment,class_id,'\')];
     system(creat_img_augment_sub_folder);
end

circulation = 1;
first_time_augment = 1;
for i = 1: length(augment_class)
    class_id=num2str(augment_class(i));
    number_of_file = length(ls(strcat(path_img,class_id)))-2;
    number_of_file_initial = number_of_file;
    while(number_of_file<augment_number)
        if first_time_augment
            for file_list = 1:number_of_file_initial
                num= num2str(file_list); 
                train_x=imread(strcat(path_img,class_id,'\',num,ext));
                new_xn=imadjust(train_x,[0.10,0.90],[]);       
                h=figure('visible','off');
                imshow(new_xn);
                set(gca,'Position',[0,0,1,1]);
                set(gcf,'PaperUnits','inches','PaperPosition',[0 0 256/150 256/150]);                
                saveas(h,[strcat(path_img_augment,class_id,'\'),num2str(number_of_file+file_list)],'tiff');
                close(h);
            end
        else
            for file_list = 1:number_of_file_initial
                gray_low = 0.10*circulation;
                gray_high= 1-gray_low;
                num= num2str(file_list); 
                train_x=imread(strcat(path_img,class_id,'\',num,ext));
                new_xn=imadjust(train_x,[gray_low,gray_high],[]);       
                h=figure('visible','off');
                imshow(new_xn);
                set(gca,'Position',[0,0,1,1]);
                set(gcf,'PaperUnits','inches','PaperPosition',[0 0 256/150 256/150]);
                saveas(h,[strcat(path_img_augment,class_id,'\'),number_of_file+num],'tiff');
                close(h);
            end
         first_time_augment = 0;
         circulation = circulation +1;
        end
       number_of_file = number_of_file + number_of_file_initial;
    end
end

            
        
            
    


	
	
	
	



























