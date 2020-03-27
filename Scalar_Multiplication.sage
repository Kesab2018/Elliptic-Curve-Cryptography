#k = Integer(getrandbits(PRECISION-1))
k=5
# We removed the most significant  bit 
l=bin(k)[3:]

Gx = Integer(G.xy()[0])
Gy = Integer(G.xy()[1])

#Scalar multiplication 
P = k*G
Px= Integer(P.xy()[0])
Py=Integer(P.xy()[1])

def PointDoubJac(p,a,b,x_P,y_P,PRECISION):

		
	
	x_Jn = x_P
	y_Jn = y_P
	z_J = r
	
	x_J = (x_Jn * r2 * rinv)%p
	y_J = (y_Jn * r2 * rinv)%p
	
	y_J2= (y_J*y_J*rinv)%p
	xy_J2 = (x_J*y_J2*rinv)%p
	t= (4*r)%p
	s= (t*xy_J2*rinv)%p
	z_J2 = (z_J*z_J*rinv)%p
	z_J4 = (z_J2*z_J2*rinv)%p
	ar = (a*r)%p
	az_J4 = (ar*z_J4*rinv)%p
	x_J2 = (x_J*x_J*rinv)%p
	t2 = (3*r)%p
	t2x=  (t2*x_J2)%p
	m= (t2x*rinv + az_J4)%p
	m2 = (m*m*rinv)%p
	t3 = (2*r)%p
	t3s = (t3*s)%p
	x_RJn= (m2 - t3s*rinv)%p
	y_J4 = (y_J2*y_J2*rinv)%p
	ms = (m*s*rinv)%p
	mx_RJn = (m*x_RJn*rinv)%p
	t4 = (8*r)%p
	t4y= (t4*y_J4*rinv)%p
	y_RJn= (ms - mx_RJn-t4y)%p
	yz_J = (y_J*z_J*rinv)%p
	t3y = (t3*yz_J)%p
	z_RJn= (t3y*rinv)%p

	
	z_RJ = (z_RJn * rinv)%p	
	x_RJ = (x_RJn * rinv)%p	
	y_RJ = (y_RJn * rinv)%p

	invz = inverse_mod(z_RJ,p)
	invz2 = (invz * invz)%p
	invz3 = (invz2 *invz)%p
	x_RA = (x_RJ * invz2)%p
	y_RA = (y_RJ * invz3)%p
	
	
	return x_RA,y_RA

def Pointaddition_Jacobi(x_P,y_P,x_Q,y_Q,p,PRECISION):
	
	x_JP = x_P
	y_JP = y_P
	z1_MD = r
	x_JQ = x_Q
	y_JQ = y_Q
	z2_MD = r
	
	x1_MD = (x_JP * r2 * rinv)%p
	y1_MD = (y_JP * r2 * rinv)%p
	
	x2_MD = (x_JQ * r2 * rinv)%p
	y2_MD = (y_JQ * r2 * rinv)%p	


	
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

	
	z_RJ = (z3_MD * rinv)%p	
	x_RJ = (x3_MD * rinv)%p	
	y_RJ = (y3_MD * rinv)%p

	invz = inverse_mod(z_RJ,p)
	invz2 = (invz * invz)%p
	invz3 = (invz2 *invz)%p
	x_RA = (x_RJ * invz2)%p
	y_RA = (y_RJ * invz3)%p
	
	
	return x_RA,y_RA

def Scalar_Mult_Jacobi(Qx,Qy,p,PRECISION):
	for i in l:
		(Qx,Qy)=PointDoubJac(p,a,b,Qx,Qy,PRECISION)
		print('doubling')
		#print'Qx:',Qx
		#print'Qy:',Qy
		#print(i)
		if i=='1':
			(Qx,Qy)=Pointaddition_Jacobi(Qx,Qy,Gx,Gy,p,PRECISION)
			#print(i)
			#print('addition')
			#print'Qx:',Qx
			#print'Qy:',Qy
			
	return (Qx,Qy)


# scalar multiplication function  calling 
(Vx_MD,Vy_MD)=Scalar_Mult_Jacobi(Gx,Gy,p,PRECISION)
print 'Px',Px
print 'Py',Py
print 'Vx',Vx_MD
print 'Vy',Vy_MD
print(Px==Vx_MD)
print(Py==Vy_MD)