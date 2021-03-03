# Automate-SSL-Certificates

This repository can be used to generate SSL certificates quickly. I wanted to avoid having the Insecure SSL Certificate error messages on serivces in my internal network, more specifically on my homelab. I am making this repository and sharing it for others who may have a similar use case to me. 

To do so, you'll need a pre-generated root key which you can use to sign the queries.

## Creating a root CA key

```
$ openssl genrsa -out root.key 4096
$ openssl req -x509 -new -nodes -key root.key -sha512 -days 3650 -out root.pem -config root.conf
```

You can verify that you have the SSL flag like this: 

```
$ openssl x509 -text -noout -in root.pem | grep CA
```

## Generating SSL keys

You'll need to configure the makeCertificate.sh and correct the paths to your certificate, and of course the distinguished_name parameters. 

Then, all you need to do to use the script is: 

```
$ bash makeCertificate.sh your.domain.local 192.168.1.10
``` 

And you should have the following files: 

- your.domain.local.conf
- your.domain.local.crt 
- your.domain.local.csr 
- your.domain.local.ext
- your.domain.local.key

Hopefully this helps. 
