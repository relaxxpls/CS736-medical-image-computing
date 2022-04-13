load('../data/assignmentImageDenoisingPhantom.mat');

%% a) The RRMSE between Noisy and Noiseless image
error = abs(rrmse(imageNoiseless, imageNoisy));
display(error);

%% b) Parameter values + RRMSE for denoising algos
