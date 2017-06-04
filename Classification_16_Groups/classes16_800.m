clear all
clc
close all
path_train = '..\class16\';
ext = '.tif';
%%ori train and test sample number
ori_train_num = 600;
ori_test_num = 200;
%%sub graph train and test sample number
tot_sample=800*16;
train_sample=9600;
test_sample=3200;
%%do similarity analyse subgraph test number
simi_test_num=12800;
%%initialize sapce
all_xn=zeros(32,32,tot_sample*64);
all_yn=zeros(16,      tot_sample*64);
train_xn=zeros(32,32,(train_sample*64));
train_yn=zeros(16,     (train_sample*64));
test_xn=zeros(32,32, (test_sample*64));
test_yn=zeros(16,      (test_sample*64));
test_final_xn=zeros(32,32,simi_test_num*16);
test_final_yn=zeros(16,   simi_test_num*16);
%%sample number of each class
sample=zeros(1,16);
sample=[800,800,800,800,800,800,800,800,800,800,800,800,800,800,800,800];
sample2=sample*64;

%%select original train samples
train_sel=randperm(800,600);
all=[1:800];
test_sel=setdiff(all,train_sel);   
test_sel=test_sel(randperm(numel(test_sel)));
%%initilize count
n=1;
m=1;
last_train_sample_num=0;
last_test_sample_num =0;

%%read data
for all_file=1:16   
 train_file_num=num2str(all_file);
  for i = 1:ori_train_num
     num= num2str(train_sel(i)); 
     train_x=im2double(imread(strcat(path_train,train_file_num,'\',num,ext))); 
    for j=1:8
      for k=1:8
        train_xn(:,:,n)=train_x((j:8:256),(k:8:256),1);
        n=n+1;
      end
    end  
  end
 train_yn(all_file,last_train_sample_num+1:n-1)=1;
 last_train_sample_num=n-1;
end 

%%%%read test samples and spilt them into 64 subgraph
for all_file=1:16
 test_file_num=num2str(all_file);
  for i = 1:ori_test_num
     num= num2str(test_sel(i)); 
     test_x=im2double(imread(strcat(path_train,test_file_num,'\',num,ext))); 
    for j=1:8
      for k=1:8
        test_xn(:,:,m)=test_x((j:8:256),(k:8:256),1);
        m=m+1;
      end
    end  
  end
 test_yn(all_file,last_test_sample_num+1:m-1)=1;
 last_test_sample_num=m-1;
end 

rand('state',0)
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer outputmaps: numbers of filters
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer 
    struct('type', 's', 'scale', 2) %subsampling layer
};
opts.alpha = 1;
opts.batchsize = 10;
opts.numepochs = 15;
opts.stepsize = 10;
cnn.activation = 'Sigmoid'; % now we have Relu and Sigmoid activation functions
cnn.pooling_mode = 'Mean'; %now we have Mean and Max pooling
% cnn.output = 'Softmax';% noe we have Softmax and Sigmoid output function
cnn.output='Sigmoid';
opts.iteration = 1;
cnn = cnnsetup(cnn, train_xn, train_yn);
for i = 1 : opts.iteration
    cnn = cnntrain(cnn, train_xn, train_yn, opts);
    [er, bad] = cnntest(cnn, test_xn, test_yn);
    [er_simi,bad_simi,simi_matrix,test_net]=cnnsimilarity(cnn,test_xn,test_yn,simi_test_num);  
    fprintf('%d iterations and rate of error : %d\n',i,er);
    if mod(i,opts.stepsize) == 0
        opts.alpha = opts.alpha/10;%change learning rate
    end
end
fprintf('Taux of error : %d\n',er(i));
%plot mean squared error
figure; plot(cnn.rL);
% assert(er<0.12, 'Too big error');
save('classes16_800_epoches15_batch10_alpha1.mat','cnn','er','er_simi','bad','bad_simi','simi_matrix','test_net');
saveas(gca,'classes16_800_epoches15_batch10_alpha1','jpg');
