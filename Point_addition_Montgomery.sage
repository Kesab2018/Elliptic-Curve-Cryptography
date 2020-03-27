#Declaration of Elliptic Curve

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

#Generation of randm Point  P

k = Integer(getrandbits(PRECISION-1))
P = k*G

x1 = Integer(P.xy()[0])
y1 = Integer(P.xy()[1])
z1 = 1
print 'Calculating random Point P with P = k*G and k: ', k
print 'x1: ',x1
print 'y1: ',y1
print 'z1: ',z1

#Montgomery form of Point P
x1_MD=x1*r2*rinv %p;
y1_MD=y1*r2*rinv %p;
z1_MD=r



print'Calculating montogomery form of point P'
print 'x1_MD: ',x1_MD
print 'y1_MD: ',y1_MD
print 'z1_MD: ',z1_MD

#Generation of randm Point  Q
k = Integer(getrandbits(PRECISION-1))
Q = k*G

x2 = Integer(Q.xy()[0])
y2 = Integer(Q.xy()[1])
z2 = 1
print 'Calculating random Point Q with Q = k*G and k: ', k
print 'x2: ',x2
print 'y2: ',y2
print 'z2: ',z2

#Montgomery form of Point P
x2_MD=x2*r2*rinv %p;
y2_MD=y2*r2*rinv %p;
z2_MD=r%p

print'Calculating montogomery form of point Q'
print 'x2_MD: ',x2_MD
print 'y2_MD: ',y2_MD
print 'z2_MD: ',z2_MD


def Pointaddition_Jacobi(x1_MD,y1_MD,z1_MD,x2_MD,y2_MD,z2_MD,p,PRECISION):
	Z1_MD=((z1_MD*z1_MD) * rinv )%p
	Z2_MD=(z2_MD*z2_MD) * rinv %p
	U1_MD=((x1_MD*Z2_MD) * rinv )%p
	U2_MD=((x2_MD*Z1_MD)* rinv )%p
	C2_MD=((z2_MD*Z2_MD) * rinv )%p
	S1=((y1_MD*C2_MD) *rinv)%p
	C1_MD = ((z1_MD*Z1_MD) * rinv )%p
	S2=((y2_MD*C1_MD) * rinv )%p
	H=(U2_MD - U1_MD) %p
	t= (2 * r2 * rinv ) % p
	q=((t*H) * rinv )%p	
	I=((q*q) * rinv )%p
	J=((H*I) * rinv )%p
	s=(S2-S1)%p
	l=((t*s)*rinv )%p
	V=((U1_MD*I) * rinv)%p
	l2= ((l * l ) * rinv ) %p
	V1=((t * V) * rinv ) %p
	x3_MD = (l2 - J - V1)%p
	Vx3= (V-x3_MD) %p
	lVx3= ((l * Vx3 ) * rinv ) % p
	S1J=((S1 * J ) * rinv) %p
	tS1J= ((t * S1J ) * rinv ) % p
	y3_MD = (lVx3 - tS1J)%p
	M=(z1_MD + z1_MD) %p
	N=((M*M)*rinv ) % p
	O= (N - Z1_MD -Z2_MD ) % p
	z3_MD = ((O * H) * rinv)%p
	print 'Calculating x3, y3  and z3 in jacobi coordinate'
	#print 'x3_MD: ',x3_MD
	#print 'y3_MD: ',y3_MD
	#print 'z3_MD: ',z3_MD
	return (x3_MD,y3_MD,z3_MD)

(X3,Y3,Z3)=Pointaddition_Jacobi(x1_MD,y1_MD,z1_MD,x2_MD,y2_MD,z2_MD,p,PRECISION)

X3_J=X3*rinv % p
Y3_J=Y3*rinv %p
Z3_J=Z3*rinv %p

Z3_JINV=inverse_mod(Z3_J,p)
Z3_JINV2 = (Z3_JINV * Z3_JINV) % p

Z3_JINV3 = (Z3_JINV * Z3_JINV2) % p


X3_A=(X3_J * Z3_JINV2 ) %p
Y3_A=(Y3_J *Z3_JINV3)%p

# Cross Check

print 'X3_A: ',X3_A

print 'Y3_A: ',Y3_A

R=P+Q

X3_t=Integer(R.xy()[0])
Y3_t=Integer(R.xy()[1])

print (X3_t==X3_A)
print (Y3_t==Y3_A)




