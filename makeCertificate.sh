#!/bin/sh

if [ "$#" -ne 1 ]
then
  excho "Usage: must supply a domain"
  exit 1
fi

DOMAIN=$1

mkdir -p ~/ca/$DOMAIN
cd ~/ca/$DOMAIN

/usr/bin/openssl genrsa -out $DOMAIN.key 4096

cat >$DOMAIN.conf <<EOF
[req]
prompt = no
default_bits = 4096
default_md = sha512
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
distinguished_name = dn
basicConstraints = ext
subjectAltName = @alt_names

[dn]
C=US
ST=NY
L=NY
O=Frosty Labs
CN=$DOMAIN

[ext]
basicConstraints=CA:FALSE

[alt_names]
DNS.1 = $DOMAIN
EOF

/usr/bin/openssl req -new -key $DOMAIN.key -out $DOMAIN.csr -config $DOMAIN.conf

/usr/bin/openssl x509 -req -in $DOMAIN.csr \
  -CA ~/ca/root/root.pem \
  -CAkey ~/ca/root/root.key \
  -CAcreateserial \
  -out $DOMAIN.crt -days 365 -sha512 \
  -extfile $DOMAIN.conf

echo "[*] Done"
