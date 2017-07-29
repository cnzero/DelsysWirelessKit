function testRandomMove()
    L = InitGHand(5);
    for i=1:10
        n = unidrnd(3)
        switch n
            case 1
                smovePaper(L);
            case 2
                smoveRock(L);
            case 3
                smoveScissor(L);
        end
        pause(0.5)
    end
end