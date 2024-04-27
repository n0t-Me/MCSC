from random import randint
from secret import flag


NUM_KEYS = 2024

def keys_gen(n):
    keys = [ [randint(1,307) for __ in range(6)] for _ in range(n)]
    return keys

def OP(msg,key):
    K = key * ((1+ len(msg))//len(key))
    return [ ( _k**5 - _m *_k +_m - _k**2 +1 )%307 for _m,_k in zip(msg,K)]


def encrypt(flag, keys):
    enc = flag
    for key in keys:
        enc = OP(flag,key) 
    return enc

keys = keys_gen(NUM_KEYS)

with open("Output.txt", "w") as text_file:
    hint = encrypt(b"Urgent",keys)
    enc = encrypt(flag, [hint])
    text_file.write(f"{enc = }\n")
    #text_file.write(f"{hint = }\n")  #Nah enough hint for you
