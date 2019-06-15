function [FTrain,FTest]=randomLBP_features(TrainSamples,TestSamples, NumberofHiddenNeurons)
% randomLBP_features used to extract features by using random LBP
% method.
% Usage: [FTrain,FTest]=randomLBP_features(TrainSamples,TestSamples, NumberofHiddenNeurons, NumberofHistBins)
% Input:
% TrainSamples,TestSamples - Original training and testing patches, each column is a patch
% NumberofHiddenNeurons - Number of randomly generate features

NumberofInputFeatures=size(TrainSamples,1);
mp=(NumberofInputFeatures+1)/2;
% Subtract the value of center voxel of the patch
TrainSamples=TrainSamples-ones(NumberofInputFeatures,1)*TrainSamples(mp,:);
TestSamples=TestSamples-ones(NumberofInputFeatures,1)*TestSamples(mp,:);

% Generate random vectors
InputWeight=rand(NumberofHiddenNeurons,NumberofInputFeatures)*2-1;
% 
tempTrain=InputWeight*TrainSamples;
tempTest=InputWeight*TestSamples;
clear TrainSamples TestSamples;                 %   Release input data 
FTrain=hardlim(tempTrain);
FTest=hardlim(tempTest);

