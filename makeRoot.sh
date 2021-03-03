#!/bin/bash

/usr/bin/mkdir -p  ./ca/root/
cd ./ca/root/

cat > <<EOF
[req]
prompt = no
default_bits = 4096
default_md = sha512
distinguished_name = dn
x509_extensions = my_extensions

[dn] 
# Update these parameters
C=US
ST=NY
L=NY
O=Frosty Labs
CN=frosty.labs.local

[my_extensions]
basicConstraints = critical, CA:TRUE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always, issuer:always
keyUsage = critical,  cRLSign, digitalSignature, keyCertSign

# Commented out because not sure if RootCA should have these defined
# subjectAltName = @alt_ca

# [alt_ca]
# DNS.1 = frosty.labs.local
# IP=10.0.0.10

EOF

/usr/bin/openssl genrsa -out root.key 4096
/usr/bin/openssl req -x509 -new -nodes -key root.key -sha512 -days 3650 -out root.pem -config root.conf

/usr/bin/openssl x509 -in root.pem -outform der -out root.crt

/usr/bin/echo "[*] Made root"
