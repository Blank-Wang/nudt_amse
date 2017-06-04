clear all
clc
close all
path_train = '..\class4\';
ext = '.tif';
%%initilize sapce
all_xn=zeros(32,32,(3000+3000+3000+3000)*64);
all_yn=zeros(4,    (3000+3000+3000+3000)*64);
train_xn=zeros(32,32,9000*64);
train_yn=zeros(4,    9000*64);
test_xn=zeros(32,32,3000*64);
test_yn=zeros(4,    3000*64);
%%chose training data randemly
train_sel=randperm(3000,2250);
all=[1:3000];
test_sel=setdiff(all,train_sel);   
test_sel=test_sel(randperm(numel(test_sel)));
%%read train data
n=1;
  for i = 1:2250 
     num= num2str(train_sel(i)); 
     train_x=im2double(imread(strcat(path_train,'1','\',num,ext))); 
    for j=1:8
      for k=1:8
        train_xn(:,:,n)=train_x((j:8:256),(k:8:256),1);
        n=n+1;
      end
    end       
  end
 
for i = 1:2250 
     num= num2str(train_sel(i)); 
     train_x=im2double(imread(strcat(path_train,'2','\',num,ext))); 
    for j=1:8
      for k=1:8
        train_xn(:,:,n)=train_x((j:8:256),(k:8:256),1);
        n=n+1;
      end
    end 
 end

for i = 1:2250 
     num= num2str(train_sel(i)); 
     train_x=im2double(imread(strcat(path_train,'3','\',num,ext))); 
    for j=1:8
      for k=1:8
        train_xn(:,:,n)=train_x((j:8:256),(k:8:256),1);
        n=n+1;
      end
    end 
end

for i = 1:2250 
     num= num2str(train_sel(i)); 
     train_x=im2double(imread(strcat(path_train,'4','\',num,ext))); 
    for j=1:8
      for k=1:8
        train_xn(:,:,n)=train_x((j:8:256),(k:8:256),1);
        n=n+1;
      end
    end 
end
%%read test data
m=1;
  for i = 1:725 
     num= num2str(test_sel(i)); 
     test_x=im2double(imread(strcat(path_train,'1','\',num,ext))); 
    for j=1:8
      for k=1:8
        test_xn(:,:,m)=test_x((j:8:256),(k:8:256),1);
        m=m+1;
      end
    end       
  end

for i = 1:725 
     num= num2str(test_sel(i)); 
     test_x=im2double(imread(strcat(path_train,'2','\',num,ext))); 
    for j=1:8
      for k=1:8
        test_xn(:,:,m)=test_x((j:8:256),(k:8:256),1);
        m=m+1;
      end
    end       
  end

for i = 1:725 
     num= num2str(test_sel(i)); 
     test_x=im2double(imread(strcat(path_train,'3','\',num,ext))); 
    for j=1:8
      for k=1:8
        test_xn(:,:,m)=test_x((j:8:256),(k:8:256),1);
        m=m+1;
      end
    end       
  end

for i = 1:725 
     num= num2str(test_sel(i)); 
     test_x=im2double(imread(strcat(path_train,'4','\',num,ext))); 
    for j=1:8
      for k=1:8
        test_xn(:,:,m)=test_x((j:8:256),(k:8:256),1);
        m=m+1;
      end
    end       
end
%%set labers
train_yn(1,1:2250*64)=1;
train_yn(2,2250*64+1:4500*64)=1;
train_yn(3,4500*64+1:6750*64)=1;
train_yn(4,6750*64+1:9000*64)=1;
test_yn(1,1:750*64)=1;
test_yn(2,750*64+1:1500*64)=1;
test_yn(3,1500*64+1:2250*64)=1;
test_yn(4,2250*64+1:3000*64)=1; 

%%CNN structor
rand('state',0)
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize',5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer   
    };

%%parameters
opts.alpha = 1;
opts.batchsize = 10;
opts.numepochs = 15;
%%set up and train cnn
cnn = cnnsetup(cnn, train_xn, train_yn);
cnn = cnntrain(cnn, train_xn, train_yn, opts);
%%test accuracy
[er, bad] = cnntest(cnn, test_xn, test_yn);
%%plot loss
figure; plot(cnn.rL);
ylabel('CNN的均方误差MSE')
xlabel('训练用数据的Batch数量')
title(['测试数据的准确率',num2str(1-er)])
%%print accuracy
1-er
%%save loss and trained cnn
save('ori_classes4_3000_mixture_epoch15_batch10_alpha1.mat','cnn','er','opts','bad');
saveas(gca,'ori_classes4_3000_mixture_epoch15_batch10_alpha1','jpg');