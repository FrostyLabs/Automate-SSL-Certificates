# Automate-SSL-Certificates 🔑

This repository can be used to generate SSL certificates quickly. I wanted to avoid having the Insecure SSL Certificate error messages on serivces in my internal network, more specifically on my homelab. I am making this repository and sharing it for others who may have a similar use case to me. 

To do so, you'll need a pre-generated root key which you can use to sign the queries.

## Creating a root CA key
Let's start with the creation of a root certificate. To do this, open makeRoot.sh and change the `yourPath` variable to your choice.

After closing the file the permissions must be adjusted for this the following command must be executed

```
chmod +x makeRoot.sh
```

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

You'll need to configure the `distinguished_name`, `yourPath`, `rootPath` within makeCertificate.sh.

However, all you need to do to use the script is define the FQDN you would like to use, and the IP address of which the host is to be accessed on. The arguments can be used as shown in the examples below.

```
$ bash makeCertificate.sh -d 'your.domain.local' -i '192.168.1.10' -n 'nameOfCertificate'
``` 
```
$ bash makeCertificate.sh -domain 'your.domain.local' -ip '192.168.1.10' -name 'nameOfCertificate'
``` 
```
$ bash makeCertificate.sh --domain 'your.domain.local' --ip '192.168.1.10' --name 'nameOfCertificate'
``` 

And you should have the following files: 

- nameOfCertificate.conf
- nameOfCertificate.crt 
- nameOfCertificate.csr 
- nameOfCertificate.ext
- nameOfCertificate.key

Hopefully this helps. 

## Community Contributors

- [@UnRunDead](https://github.com/unrundead)
