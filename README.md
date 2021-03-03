# Automate-SSL-Certificates 🔑

This repository can be used to generate SSL certificates quickly. I wanted to avoid having the Insecure SSL Certificate error messages on serivces in my internal network, more specifically on my homelab. I am making this repository and sharing it for others who may have a similar use case to me. 

To do so, you'll need a pre-generated root key which you can use to sign the queries.

## Creating a root CA key

You only need to perform this step once. This key is used to sign any keys which we will generate afterwards. You will need to install this your generated key into your trusted certificate store.

```
$ makeRoot.sh
```

You can verify that you have the `CA:TRUE` flag like this: 

```
$ openssl x509 -text -noout -in ./ca/root/root.pem | grep CA
```

You should have these files if it worked as planned: 

- root.conf
- root.crt
- root.key
- root.pem
- root.srl



## Generating SSL keys

You'll need to configure the `distinguished_name` within makeCertificate.sh and if you like, correct the paths to your root certificate. The script works as it is though, but if you use your your own paths then there might be some adjustment required. It would be a great addition to add some optional parameters to the `makeCertificate.sh` script so that it would be more adaptable for different environments. This is something that I may do in the future. 

However, all you need to do to use the script is define the FQDN you would like to use, and the IP address of which the host is to be accessed on.  

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
