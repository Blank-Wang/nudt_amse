clear all
clc
close all

path1 = '..\class2\1\';
path2 = '..\class2\2\';
ext = '.tif';
%%set train and test data number
tot_number_each_class = 4000;
train_number_each_class = 3000;
test_number_each_class = 1000;
class = 2;
%%initilize space
all_xn=zeros(32,32,(tot_number_each_class*class)*64);
all_yn=zeros(2,    (tot_number_each_class*class)*64);
train_xn=zeros(32,32,train_number_each_class*class*64);
train_yn=zeros(2,    train_number_each_class*class*64);
test_xn=zeros(32,32,test_number_each_class*class*64);
test_yn=zeros(2,    test_number_each_class*class*64);
%%chose training data randemly
train_sel=randperm(tot_number_each_class,train_number_each_class);
all=[1:tot_number_each_class];
test_sel=setdiff(all,train_sel);   
test_sel=test_sel(randperm(numel(test_sel)));
%%read class1 train data
n=1;
  for i = 1:train_number_each_class 
     num= num2str(train_sel(i)); 
     train1_x=rgb2gray(im2double(imread(strcat(path1,num,ext)))); 
    for j=1:8
      for k=1:8
        train_xn(:,:,n)=train1_x((j:8:256),(k:8:256),1);
        n=n+1;
      end
   end  
  end
  train_yn(1,1:train_number_each_class*64)=1; 
  
%%read class2 train data
  for i = 1:train_number_each_class 
     num= num2str(train_sel(i)); 
     train2_x=rgb2gray(im2double(imread(strcat(path2,num,ext))));
         for j=1:8
             for k=1:8
        train_xn(:,:,n)=train2_x((j:8:256),(k:8:256),1);
        n=n+1;
             end
         end 
  end
  train_yn(2,train_number_each_class*64+1:train_number_each_class*class*64)=1;
 %%read class1 test data
 m=1;
  for i = 1:test_number_each_class 
     num= num2str(test_sel(i)); 
     test1_x=rgb2gray(im2double(imread(strcat(path1,num,ext)))); 
    for j=1:8
      for k=1:8
        test_xn(:,:,m)=test1_x((j:8:256),(k:8:256),1);
        m=m+1;
      end
   end  
  end
  test_yn(1,1:test_number_each_class*64)=1; 
%%read class2 test data
  for i = 1:test_number_each_class 
     num= num2str(test_sel(i)); 
     test2_x=rgb2gray(im2double(imread(strcat(path2,num,ext))));
         for j=1:8
             for k=1:8
        test_xn(:,:,m)=test2_x((j:8:256),(k:8:256),1);
        m=m+1;
             end
         end 
  end
  test_yn(2,test_number_each_class*64+1:test_number_each_class*class*64)=1;
     
rand('state',0)

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer outputmaps: numbers of filters
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer 
    struct('type', 's', 'scale', 2) %subsampling layer
%     struct('type', 'c', 'outputmaps', 120, 'kernelsize',5 ) %0.0388
%     struct('type', 's', 'scale', 3) %subsampling layer
};


opts.alpha = 1;
opts.batchsize = 10;
opts.numepochs = 15;
opts.stepsize = 10;
cnn.activation = 'Sigmoid'; % now we have Relu and Sigmoid activation functions
cnn.pooling_mode = 'Max'; %now we have Mean and Max pooling
% cnn.output = 'Softmax';% noe we have Softmax and Sigmoid output function
cnn.output='Sigmoid';
opts.iteration = 1;
cnn = cnnsetup(cnn, train_xn, train_yn);
for i = 1 : opts.iteration
    cnn = cnntrain(cnn, train_xn, train_yn, opts);
    [er, bad] = cnntest(cnn, test_xn, test_yn);
    fprintf('%d iterations and rate of error : %d\n',i,er);
    %[er1, bad1] = cnntest(cnn, val_x, val_Label);
    %fprintf('%d iterations and rate of error (validation) : %d\n',i,er1);
    if mod(i,opts.stepsize) == 0
        opts.alpha = opts.alpha/10;%change learning rate
    end
end
%[er, bad] = cnntest(cnn, test_x, test_y);
fprintf('Taux of error : %d\n',er(i));
%plot mean squared error
figure; plot(cnn.rL);
ylabel('Mean Square Error based on CNN')
xlabel('Numbatches')
title(['Accuracy',num2str(1-er)])
1-er
% assert(er<0.12, 'Too big error');
save('my_plot_classes2_mixture_tag2_batch10_epoch15_alpha1','cnn','er','bad','opts');
saveas(gca,'my_plot_classes2_mixture_tag2_batch10_epoch15_alpha1','jpg')