PRECISION = 192

p = 2^192 - 2^64 - 1

r = 2^192 % p
r2 = r * r % p
rinv = inverse_mod(r,p)

F = FiniteField(p)
a = -3 % p
b = 0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1 % p

C = EllipticCurve(F,[a,b])

G = C.point((0x188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012,0x07192b95ffc8da78631011ed6b24cdd573f977a11e794811))

x_G = Integer(G.xy()[0])
y_G = Integer(G.xy()[1])


k = Integer(getrandbits(PRECISION-1))
P = k*G

x1 = Integer(P.xy()[0])
y1 = Integer(P.xy()[1])
z1 = 1
print 'Calculating random Point P with P = k*G and k: ', k
print 'x1: ',x1
print 'y1: ',y1
print 'z1: ',z1

k = Integer(getrandbits(PRECISION-1))
Q = k*G

x2 = Integer(Q.xy()[0])
y2 = Integer(Q.xy()[1])
z2 = 1
print 'Calculating random Point Q with Q = k*G and k: ', k
print 'x2: ',x2
print 'y2: ',y2
print 'z2: ',z2


Pointaddition_Jacobi(x1,x2,z1,x2,y2,z2,p,PRECISION)

R = P+Q
xR = Integer(R.xy()[0])
yR = Integer(R.xy()[1])


def Pointaddition_Jacobi(x1,y1,z1,x2,y2,z2,p,PRECISION):
    Z1_Square=(z1*z1)%p
    Z2_Square=(z2*z2)%p
    U1=(x1*Z2_Square)%p
    U2=(x2*Z1_Square)%p
    S1=(y1*z2*Z2_Square)%p
    S2=(y2*z1*Z1_Square)%p
    H=(U2 - U1)%p
    I=((2*H)^2)%p
    J=(H*I)%p
    r=(2*(S2-S1))%p
    V=(U1*I)%p
    x3 = (r*r - J - 2*V)%p
    y3 = (r* (V - x3) - 2 *S1*J)%p
    z3 = (((z1+z2)^2 - Z1_Square - Z2_Square) * H)%p
    print 'Calculating x3, y3  and z3 in jacobi coordinate'
    #print 'x3: ',x3
    #print 'y3: ',y3
    #print 'z3: ',z3
    return (x3,y3,z3)

(x3,y3,z3) = Pointaddition_Jacobi(x1,y1,z1,x2,y2,z2,p,PRECISION)

z3_inv = inverse_mod(z3,p)

z3_inv2 = (z3_inv * z3_inv) % p

z3_inv3 = (z3_inv * z3_inv2) % p

xR_test = (x3 * z3_inv2) % p
yR_test = (y3 * z3_inv3) % p

# Cross Checking
print xR == xR_test
print yR == yR_test




#Formulas


#compute Z1Z1 = Z1^2
#compute Z2Z2 = Z2^2
#compute U1 = X1 Z2Z2
#compute U2 = X2 Z1Z1
#compute S1 = Y1 Z2 Z2Z2
#compute S2 = Y2 Z1 Z1Z1
#compute H = U2-U1
#compute I = (2 H)^2
#compute J = H I
#compute r = 2 (S2-S1)
#compute V = U1 I
#compute X3 = r^2-J-2 V
#compute Y3 = r (V-X3)-2 S1 J
#compute Z3 = ((Z1+Z2)^2-Z1Z1-Z2Z2) H
