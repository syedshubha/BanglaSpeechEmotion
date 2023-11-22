clear;
close all;
clc

load('Data');

classifier = input('Which classification model do you want to you?\n1.Decision-tree\n2.Discriminant-analysis\n3.Support-Vector Machine\n4.Naive-Bias\n');

if classifier == 1
    fprintf('Preparing decision-tree Classifier.\n');
    classificationModel = fitctree(TrainData, TrainClass);
    fprintf('decision-tree Classifier Ready\n');
elseif classifier == 2
    fprintf('Preparing discriminant-analysis Classifier.\n');
    classificationModel = fitcdiscr(TrainData, TrainClass);
    fprintf('discriminant-analysis Classifier Ready\n');
elseif classifier == 3
    fprintf('Preparing SVM Classifier.\n');
    classificationModel = fitcecoc(TrainData, TrainClass);
    fprintf('SVM Classifier Ready\n');
else 
    fprintf('Preparing naive-bias Classifier.\n');
    classificationModel = fitcnb(TrainData, TrainClass);
    fprintf('naive-bias Classifier Ready\n');
end

prediction = [];
for i = 1 : size(TestData, 1)
        label = predict(classificationModel, TestData(i, :));
        prediction = [prediction; label];
end  

fprintf('Confusion Matrix\n');
C = confusionmat(TestClass, prediction)
acc = mean(TestClass == prediction)