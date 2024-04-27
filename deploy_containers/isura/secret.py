from random import randint 


def ziyer_t3ich_mkhiyer(x,y):
    x,y = min(x,y), max(x,y)
    k   = randint(2**1000,(y-x)//2 )
    
    return (y-x)//2 -k , (x+y)//2 +k  , k

flag = b"MCSC{7h3_3n3mY_Kn0w5_7h3_5yS73m...Cl4ud3_5h4nN0n}"