function testRandomMove()
    L = InitGHand(5);
    for i=1:20
        n = unidrnd(3)
        switch n
            case 1
                smovePaper(L);
            case 2
                smoveRock(L);
            case 3
                smoveScissor(L);
        end
        pause(1.5)
    end
end