# nudt_amse
Classification and Similarity Analysis of Whale Calls
This MATLAB code mainly uses convolutional neural network (CNN) to classify whale calls and do similarity analysis. In addition, the similarity analysis also used SPSS software and Phylip software.
Phylip software download address: http://evolution.gs.washington.edu/phylip/

The main implementation procedure are described below.
1.	Convert MP3 files of whale calls into spectrum with TIFF format.
	Execute the ‘transfer_mp3_to_spectrogram.m’ file, which reads the audio file from the audio datasets as well as generates the spectrogram images, and then saves them in the whale_sound_img folder. A group of images with the same recording ID are collected in corresponding subfolder named by their recording ID. 

2.	Divide the images into two classes and four sub-populatinos
(1)	Execute the file of ‘creat_folder_to_different_test.m’ , which creates the corresponding vacant folders and subfolders to save the divided. They are class2, class4 and class16.
(2)	Divide all images into two species which are pilot whales and killer whales. Specifically, the group of pilot whales consists of the images with the recording ID of 1,2,3,4,15,17 and 19, and the other group of killer whales consists of 6,7,22,8,9,10,12,13 and 24. Then you need to put them into the corresponding folders respectively. ( The corresponding folders are ‘./class2/1/’ and ‘./class2/2/’). Besides, you need to rename this images by order(Here you can use the bitch processing file rename.bat provided to make it, finally, all the images in the same folder should be sorted as 1.tif, 2.tif, 3.tif, 4.tif …… etc.)
(3)	Divide all images into four subpopulations, they are, Bahamas short-finned whales, Icelandic killer whales, Norwegian killer whales and Norwegian long-finned whales. The method is just as mentioned above. Finally, the pods of 1,2,3,4 are collected into the first group, 6,7,22 are collected into the second group, 8,9,10,12,13,24 are collected into the third group, and 15,17,19 are the fourth group.
(4)	Copy all the data in the folder of whale_sound_img to class16.

3.	Augment the data by using the MATLAB function of ‘imgadjust’.
	Execute the file ‘augment_data’, which augment the dataset by adjusting the grayscale of images as well as merging the augmented data into initial datasets.
	In our experiment, we augmented the dataset to an appropriate amount, which are:
	Class4: 3000+ each subpopulations;
	Class16: 800+ each pod.
  
4.	Train CNN and test.
(1)	Execute the file of class2_4000.m in classify_2.
(2)	Execute the file of class4_3000.m in classify_4.
(3)	Execute the file of class16_800.m in classify_16.

5.	Similarity analyzation and visualization
(1)	When you completed the process above, you can get a matrix ‘simi_matrix.mat’, which is a ‘probability sum’ with a size of 16*16 used to describe the similarity among the pods.
Copy the simi_matrix.mat to the folder ‘plot similarity 16_16’, then execute the file of ‘visulize_similarity16.m’ and you will get the results of visualization.
(2)	Based on the simi_matrix.mat , use SPSS to do the further similarity analyzation.
Execute the procedure of ‘Analyze-classify-Hierarchical cluster’ and choose the Square Euclidean to describe the similarity among the samples. Our experiment result is showed as Tabel 1.
Table 1
 
Meanwhile, you can get a Square Euclidean distance matrix A.

(3) Using Phylip to draw the phylogency.
	Using the phylip fitch algorithm to get the outtree and no-bady algorithm to improve the tree, then get the final phylogency.
