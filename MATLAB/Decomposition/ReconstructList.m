% Function description
%      from the known [aList] with [idx] labels to reconstruct several whole sequential list
% Input: 
%       [aList], 1xL, known sequential list
%       [SpikesX], nS x 17, every row stands for a spike location. 
%       [idx], nS x 1, every element stands for the cluster label [1,2,3, ... 10]
% Output:
%       [reList], 10xL, target sequential list with every row is reconstructed with the same-labeled Spikes.

function reList = ReconstructList(aList, SpikesX, idx)
    labels = length(unique(idx)); % - 10 for example
    L = size(aList, 2); % - length of known or target sequential list.
    reList = zeros(labels, L);
    for lb=1:labels
        SpikesLabel = SpikesX(idx==lb, :); % Spikes Location matrix with the same label
        LengthSpikesLabel = size(SpikesLabel, 1); % how many Spikes with that label
        for i=1:LengthSpikesLabel
            spikesX = SpikesX(i, :);  % - a spike location with that label
            reList(lb, :) = reList(lb, :) + FillingZeros(aList, spikesX);
        end
    end
end