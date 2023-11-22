clear
close all
clc

load('Data');
classifier = input('Which classification model do you want to use?\n1.K-Nearest Neighbour\n2.Dynamic Time Warping\n');
if classifier == 1
    [ConfMat, accuracy] = KnnClassifier(1, TrainData, TrainClass, TestData, TestClass)
else
    [ConfMat, accuracy] = DtwClassifier(1, TrainData, TrainClass, TestData, TestClass)
end