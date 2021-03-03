#!/bin/sh

if [ "$#" -ne 2 ]
then
  echo "Usage: must supply a domain, and IP address"
  exit 1
fi

DOMAIN=$1
IP=$2

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
basicConstraints = CA:FALSE

[dn]
C=CH
ST=ZH
L=ZH
O=Frosty Labs
CN=$DOMAIN

EOF

cat >$DOMAIN.ext <<EOF
authorityKeyIdentifier = keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1=$DOMAIN
IP=$IP
EOF

/usr/bin/openssl req -new -key $DOMAIN.key -out $DOMAIN.csr -config $DOMAIN.conf

/usr/bin/openssl x509 -req -in $DOMAIN.csr \
  -CA /opt/ca/root/root.pem \
  -CAkey /opt/ca/root/root.key \
  -CAcreateserial \
  -out $DOMAIN.crt -days 365 -sha512 \
  -extfile $DOMAIN.ext

echo "[*] Done"
