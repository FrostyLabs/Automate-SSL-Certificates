#!/bin/sh

if [ "$#" -ne 2 ]
then
  /usr/bin/echo "Usage: must supply a domain, and IP address"
  /usr/bin/echo "Example: bash makeCertificate.sh your.domain.local 192.168.1.10"
  exit 1
fi

DOMAIN=$1
IP=$2

/usr/bin/mkdir -p ./ca/$DOMAIN
cd ./ca/$DOMAIN

/usr/bin/openssl genrsa -out $DOMAIN.key 4096

cat >$DOMAIN.conf<<EOF
[req]
prompt = no
default_bits = 4096
default_md = sha512
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltNames = @alt_names
distinguished_name = dn

[dn]
C=US
ST=NY
L=NY
O=Frosty Labs
CN=$DOMAIN

[alt_names]
DNS.1=$DOMAIN
IP=$IP
EOF

cat >$DOMAIN.ext<<EOF
authorityKeyIdentifier = keyid,issuer
basicConstraints=CA:FALSE
subjectKeyIdentifier = hash
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1=$DOMAIN
IP=$IP
EOF

/usr/bin/openssl req -new -key $DOMAIN.key -out $DOMAIN.csr -config $DOMAIN.conf

/usr/bin/openssl x509 -req -in $DOMAIN.csr \
  -CA ./ca/root/root.pem \
  -CAkey ./ca/root/root.key \
  -CAcreateserial \
  -extfile $DOMAIN.ext \
  -out $DOMAIN.crt -days 365 -sha512
  
/usr/bin/echo "[*] Done"
