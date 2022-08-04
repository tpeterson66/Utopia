# Certbot using Docker

Certbot is a great utlitiy to manage LetsEncrypt certificates, which are valid third-party certificates which expire after 90 days. These LetsEncryt certificates are great for testing apps or services which require TLS. Here is a quick guide on how to use Certbot and Docker to quickly create certificates for your domain.

## Certbot

Certbot is a free and open-source tool which uses LetsEncrypt or other ACME based certificate generators to create and manage certificates. [Certbot](https://certbot.eff.org/) is well documented and used in many different projects to manage certificates for services.

## Docker

Docker, a well know container management tool, can also be used to run the certbot software as a container. This is important as this option does not require you to install certbot on your local machine or require you to update certbot to use the latest version.

Docker can be installed on your local machine using the following link: <https://docs.docker.com/engine/install/>. More information on docker and its commands can be found here: <https://docs.docker.com/get-started/>

## Using Certbot with Docker

Here are the commands which can be used to generate some certificates for your applications and use-cases.

```bash

# command w/ comments
ocker run -it \ # run docker in interactive mode
-v $(pwd):/etc/letsencrypt/ \ # create a volume in the container w/ the current working directory
certbot/certbot \ # docker hub image for certbot
certonly \ # use certbot to pull images
--manual \ # ack the fact that this will be a manual process allowing for user input
--preferred-challenges dns \ # use DNS to validate domain ownership requiring DNS entries to be made for the doamins
--debug-challenges \ # helpful to better understand errors
-d www.devopsfu.io -d www1.devopsfu.io # provide the domains you want to create certificates for, you can create a wildcard using * as well

# command w/out comments
docker run -it -v $(pwd):/etc/letsencrypt certbot/certbot certonly --manual --preferred-challenges dns --debug-challenges -d www.devopsfu.io -d www1.devopsfu.io
```

When you run the command, you will need to answer a few questions at the beginning. Once you answer the questions, Certbot will provide you the information required to validate the domains (when using the dns challenge option). Once you enter the details required on your DNS server, you can complete the challenge.

### OpenSSL PFX File

Its easier to move certificates around as PFX, the following command can be used to create a full chain PFX file for your certificate.

```bash
openssl pkcs12 -export -out www-devopsfu-io.pfx -inkey privkey.pem -in fullchain.pem
```