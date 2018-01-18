% function description
%       detect spikes based on Peak-maximum value iterative remove.
% Input:
%       [aList], 1xL, a known list, sequential data,
%       [W], int number, half width of every spike, 2*W+1
%
% Output:
%       [restList], 1xL, a residue list as [aList] without spikes
%       [SpikesX], nx(2W+1), n spikes, with each row standing for a spike location.
%       [SpikesY], nx(2W+1), n spikes, with each row standing for a spike values. Not so necessary as [SpikesX]
% --> read more comprehensive documenatry-> docSpikesDetection.mlx
function [restList, SpikesX, SpikesY] = SpikesDetection(aList, W)
    L = size(aList, 2);
    restList = aList;
    
    SpikesX = int32.empty(0, 2*W+1);
    SpikesY = double.empty(0, 2*W+1);
    
    largest = 1;
    % 降序排序，并标明原序列中的索引位置
    [~, Index] = sort(abs(aList), 'descend');
    while rms(restList) > 0.1 * rms(aList)
        mX = Index(largest);
        
        if (mX-W >0) && (mX+W <=L)
            flagLeftIn = NumbInSpikesX(mX-W, SpikesX);
            flagRightIn = NumbInSpikesX(mX+W, SpikesX);
            if ~(flagLeftIn || flagRightIn)  % Not in existing spikes section
                spikeX = [mX-W:mX+W];
                spikeY = aList(spikeX);
                zerosFillingspikeX = FillingZeros(aList, spikeX);

                % - update
                restList = restList - zerosFillingspikeX;
                % - SpikesX location
                % - column cat
                SpikesX = cat(1, SpikesX, spikeX);
                % - SpikesY value
                % - column cat
                SpikesY = cat(1, SpikesY, spikeY);
            end
        end
        if largest < L-1
            largest = largest + 1;
        else
            break;
        end
    end
end

