clear all,close all,clc
d1 = load('Snooze.txt');
d2 = load('Rock.txt');
d3 = load('Paper.txt');
d4 = load('Scissor.txt');
d = [d1, d2, d3, d4];

% 
fE.featuresCell = {'LogD', 'MAV', 'RMS', 'SSC', 'VAR', 'WA', 'WL'};
fE.LW = 128;
fE.LI = 64;
sampleX = Rawdata2SampleMatrix(d, fE);
% figure(1);plot(d);
for n=1:length(fE.featuresCell)*2
    figure(n+1);
    plot(sampleX(:, n));
    fn = mod(n,7);
    if fn==0
        fn = 7;
    end
    title(fE.featuresCell{fn});
end
