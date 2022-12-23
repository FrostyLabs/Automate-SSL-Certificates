#!/bin/sh

while [ $# -gt 0 ]; do
  case "$1" in
    -d|-domain|--domain)
      domain="$2"
      ;;
    -i|-ip|--ip)
      ip="$2"
      ;;
    -n|-nane|--name)
      name="$2"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
  shift
done

# !!! Update these variables !!!
yourPath=/your/path/of/choice # Path where the files should be created
rootPath=/path/of/root/cert # Path to your Root Certificate
# -------

/usr/bin/mkdir -p $yourPath/$name
cd $yourPath/$name

/usr/bin/openssl genrsa -out $name.key 4096

cat >$name.conf<<EOF
[req]
prompt = no
default_bits = 4096
default_md = sha512
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltNames = @alt_names
distinguished_name = dn

# !!! Update this section !!!
[dn]
C=US
ST=NY
L=NY
O=YourCoolName
# -------
CN=$domain

[alt_names]
DNS.1=$domain
IP=$ip
EOF

cat >$name.ext<<EOF
authorityKeyIdentifier = keyid,issuer
basicConstraints=CA:FALSE
subjectKeyIdentifier = hash
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1=$domain
IP=$ip
EOF

/usr/bin/openssl req -new -key $name.key -out $name.csr -config $name.conf

/usr/bin/openssl x509 -req -in $name.csr \
  -CA $rootPath/root.pem \
  -CAkey $rootPath/root.key \
  -CAcreateserial \
  -extfile $name.ext \
  -out $name.crt -days 365 -sha512

/usr/bin/echo "[*] Done"
