% Function description
%       form a spike list to be the same length with [aList] in location of  spikeX
% Input:
%       [aList], 1xL, a known list, 
%       [spikeX], 1XW, location
% Output:
%       [aNewList], 1xL, same list with [aList] only in location of [spikeX], 
%                   any else location will be filled with zeros.
function aNewList = FillingZeros(aList, spikeX)
    if isempty(spikeX)
        aNewList = zeros(1, size(aList, 2));
    else
        aNewList1 = zeros(1, spikeX(1)-1);
        aNewList2 = aList(spikeX);
        aNewList3 = zeros(1, size(aList, 2) - spikeX(end) );
        aNewList = [ aNewList1, aNewList2, aNewList3];
    end
end