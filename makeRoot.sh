#!/bin/bash

# !!! Update this variable !!!
yourPath=/your/path/of/choice
# -------

mkdir -p  $yourPath
cd $yourPath

cat > root.conf <<EOF
[req]
prompt = no
default_bits = 4096
default_md = sha512
distinguished_name = dn
x509_extensions = my_extensions

# !!! Update this section !!!
[dn] 
C=US
ST=NY
L=NY
O=YourCoolName
CN=YourCool.Name
# -------

[my_extensions]
basicConstraints = critical, CA:TRUE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always, issuer:always
keyUsage = critical,  cRLSign, digitalSignature, keyCertSign

EOF

openssl genrsa -out root.key 4096
openssl req -x509 -new -nodes -key root.key -sha512 -days 3650 -out root.pem -config root.conf

openssl x509 -in root.pem -outform der -out root.crt

echo "[*] Created root certificates"
