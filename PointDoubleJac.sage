def PointDoubJac(p,a,b,x_G,y_G,PRECISION):

	k = Integer(getrandbits(PRECISION-1))
	P = k*G
	x_P = Integer(P.xy()[0])
	y_P = Integer(P.xy()[1])
	
	print 'Calculating random Point P with P = k*G and k: ', k
	
	x_P = 4067597291484492509550768047828652471824690049465055630668
	y_P = 2569823352098576840476611131992754008913283191252272066158
	
	print 'x_P: ',x_P
	print 'y_P: ',y_P
	
		
	print 'Calculating Jacobian Counterparts'
	x_Jn = x_P
	y_Jn = y_P
	z_J = r
	print 'x_J: ',x_Jn
	print 'y_J: ',y_Jn
	print 'z_J: ',z_J
	
	print ' Transforming them into Montgomery domain'
	x_J = (x_Jn * r2 * rinv)%p
	y_J = (y_Jn * r2 * rinv)%p
	print 'x_J(mont): ',x_J
	print 'y_J(mont): ',y_J

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

	print 'Point Doubling of P yields R'
	z_RJ = (z_RJn * rinv)%p	
	x_RJ = (x_RJn * rinv)%p	
	y_RJ = (y_RJn * rinv)%p

	invz = inverse_mod(z_RJ,p)
	invz2 = (invz * invz)%p
	invz3 = (invz2 *invz)%p
	x_RA = (x_RJ * invz2)%p
	y_RA = (y_RJ * invz3)%p
	
	
	print "x_RA is ",x_RA
	print "y_RA is ",y_RA	
	

	return