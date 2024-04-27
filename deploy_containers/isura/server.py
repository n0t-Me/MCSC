from Crypto.Util.number import getStrongPrime, bytes_to_long
from Crypto.Util.Padding import pad
from secret import flag, ziyer_t3ich_mkhiyer

HDR ="""\n+------------------------------------------------------------+
|  _____   ______     __    __    _____     ____             |
| (_   _) (   __ \    ) )  ( (   / ____\   (    )            |
|   | |    ) (__) )  ( (    ) ) ( (___     / /\ \            |
|   | |   (    __/    ) )  ( (   \___ \   ( (__) )           |
|   | |    ) \ \  _  ( (    ) )      ) )   )    (            |
|  _| |__ ( ( \ \_))  ) \__/ (   ___/ /   /  /\  \           |
| /_____(  )_) \__/   \______/  /____/   /__(  )__\          |
|                                                            |
|  _____    _____      __      _    _____    _____    _____  |
| / ____\  / ___/     /  \    / )  / ____\  / ___/   (_   _) |
|( (___   ( (__      / /\ \  / /  ( (___   ( (__       | |   |
| \___ \   ) __)     ) ) ) ) ) )   \___ \   ) __)      | |   |
|     ) ) ( (       ( ( ( ( ( (        ) ) ( (         | |   |
| ___/ /   \ \___   / /  \ \/ /    ___/ /   \ \___    _| |__ |
|/____/     \____\ (_/    \__/    /____/     \____\  /_____( |
|                                                            |
+------------------------------------------------------------+\n\n"""
def NinJuTsu():
    p = getStrongPrime(1024)
    q = getStrongPrime(1024)
    n = p * q
    x, y, k = ziyer_t3ich_mkhiyer(p, q)
    e = 0x10001
    assert pow(x + k, 2, n) == pow(y - k, 2, n)
    
    m = bytes_to_long(pad(flag, 16))
    c = hex(pow(m, e, n))

    return n, e, x, y, c, p, q 

def Challenge():
    print(HDR)
    n, e, x, y, c, p, q = NinJuTsu()
    y = y >> (307 + 36) 
    print("WELCOME Young Ninja! I am Irusa, the brother of Iruka, I will teach you a  Cryptographic")
    print(" Ninjutsu! But before that I have to test you!\n")
    print("Young Ninja you have to bring me a prime factor of this modulus and I will reward you...")
    print("Show me your Number Theoritic Chakra!!!!\n")
    print("Here is the public key\n")
    print(f"{n, e = }\n")
    print("Here some useful hints\n")
    print(f"{x, y = }\n")
    user_input = int(input("\n\n Give me a prime factor of n.\n> "))
    if user_input in [p, q]:
        print("Amazing! Here is your reward: ", c)
    else:
        print("Get out from here!")

if __name__ == "__main__":
    Challenge()
