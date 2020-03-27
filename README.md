# kesabnayak4-gmail.com
Implementing Elliptic Curve Cryptography Algorithms 

In this project we have tried implemented the Diffie-Hellman key exchange prtocol in cryptocore and verified by sage math.

I was the SCRUM master of the Team of 6 and managed the Team 

Use of the CryptoCore for an ECC Diffie-Hellman key exchange
The Diffie-Hellman key exchange is a key agreement protocol. This protocol allows that
two communication partner can agree on a secret number over an unsecured communication
channel. A potential eavesdropper cannot calculate this number even if he/she possesses the
complete transferred data. The secret number agreed on can subsequently be used for deriving
a key for a symmetric cryptographic system (such as AES). Different variations of the Diffie-
Hellman key exchange method are used today in key distribution methods in communication
protocols of the Internet, therefore the principle has a fundamental importance. There also
exists a version of the Diffie-Hellman key exchange protocol based on elliptic curves .
The calculation rule of an ECC Point Addition as well as Point Doubling in affine coordinate
representation requires division-operations (thus the calculation of a multiplicative inverse element)
which is a quite time-consuming calculation. For a time-efficient calculation the transformation
into the projective Jacobi coordinates has proven itself, since no division operation is
required here in the named operations. Though, this method requires a back transformation step
in which a multiplicative inverse element must be calculated, but thin only has to be performed
once at the very end of an ECC computation.
Goal:
Within this project a Linux device driver should be extended by following ECC GF(p) functions:
Preparation, Montgomery Transformation, Affine-to-Jacobi Transformation,
Point Doubling, Point Addition, Jacobi-to-Affine Transformation,
Montgomery Back-transformation.
By using a Linux User Space Application these functions should be used to realize an ECC
Diffie-Hellman key exchange.