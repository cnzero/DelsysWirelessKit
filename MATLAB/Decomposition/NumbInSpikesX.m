% function description:
%         determine if the [Numb] is in the known sections -- every row is a sequential section.
% Input:
%       [Numb], int number;
%       [SpikesX], a matrix with nRxW
%                  every row is a sequential section
% Output:
%       [flag], true or false
%           true, in one of the sequential sections - each row
%           false, out of all the sequential sections - every row

% SpikesX, 
function flag = NumbInSpikesX(Numb, SpikesX)
    flag = 0;
    if ~isempty(SpikesX)
        nR = size(SpikesX, 1);
        i = 1;
        while i<=nR
            if Numb>=SpikesX(i, 1) && Numb<=SpikesX(i, end)
                flag = 1;
                i = nR + 1;
            end
            i = i + 1;
        end
    end
end