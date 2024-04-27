from hashlib import sha256
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad,unpad

from secret import flag

# PARAMETERS
q       = 3329
k       = 2 
sigma   = 2.5
n       = 256


### THIS CHALLENGE AIMS TO INTRODUCE US TO POST-QUANTUM SAFE CONSTRUCTIONS,
### IN THIS CHALLENGE WE WILL MEET A VARIANT  OF THE LEARNING WITH ERROR PROBLEM, CALLED MODULE-LWE 
### THE  NIST SELECTED KEM-SCHEME KYBER  RELIENS ON THE HARDNESS OF THIS PROBLEM 

# FIELDS/Ring  of Integers/ Ring of Integers mod q 

# think about it like a space of vectors/polynomials in x with rational coefficients with a special multiplication between its vectors 
K   = CyclotomicField(n,"z")  # nth-cyclotomic field, is of degree euler_phi(n) 

# think about it like a space of vectors/polynomials in x with integer coefficients with a special multiplication between its vectors 
OK      = K.OK()

# think about it like a space of vectors with coefficients in Z/qZ with a special multiplication between its vectors 
OKq= OK.quotient(q,'y')

A = matrix(K, k,k, [K(random_vector(ZZ,n//2,x=-q//2,y=q//2).list()) for _ in k*k*"_"]).lift_centered()
s = matrix(K, [K(random_vector(ZZ,n//2,sigma,distribution="gaussian").list()) for __ in k*"_"] )
e = matrix(K, [K(random_vector(ZZ,n//2,sigma,distribution="gaussian").list()) for __ in k*"_"] )
b = (s*A +e ).change_ring(OKq)  #reduction coefficients mod q 


## Genrating Hints : D 

H = matrix(k,k,[ OK(list(random_vector(ZZ,n))) for _ in k*k*"_"] )
l = s*H                                                # I won't give you this 3:)
h = floor(.25*n/2)                                                 # number of hiding
l2 = matrix([l[0,0] , OK(l[0,1].list()[:-h]) ]) # but this : ) 

key = sha256(str(s).encode()).digest()[:16]
iv  = sha256(str(e).encode()).digest()[:16]

cipher= AES.new(key,AES.MODE_CBC,iv=iv)

enc = cipher.encrypt(pad(flag,16))

cipher= AES.new(key,AES.MODE_CBC,iv=iv)

#Printing 
print(f"A  = {A.coefficients()}")
print(f"b  = {b.coefficients()}")
print(f"H  = {H.coefficients()}")
print(f"l2 = {l2.coefficients()}")
print("enc = ", enc.hex())
