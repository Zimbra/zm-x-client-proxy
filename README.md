# zm-x-client-proxy

Lightweight service for serving the Zimbra NextGen app.
Note that this does run in `docker swarm` mode in order to utilize the *configs* configuration capability.
If you are not running in swarm mode things will not work so well.

Required config files:

 - zimbra_server.cfg - hostname/ip address of the Zimbra SOAP server
 - ui_server.cfg - hostname/ip address of the UI server
 - server.pem - SSL certificate (generated automatically)
 
## Getting Started

In order to setup the initial proxy configuration run the 'setup' target:

    make setup
    
This will create empty files for:

  - zimbra_server.cfg
  - ui_server.cfg
  
These files should be filled in with the appropriate hostnames for the relevant service.
They will be used during runtime to substitute in for the relevant location in the haproxy.cfg file inside the container.
  
It will also generate a self-signed SSL certificate (assuming openssl is available) named *server.pem*.

Once the files have been edited to have the appropriate values within you can start the proxy.

    make build
    make up
    
If you wish to stop the proxy run the `make down` command from within the `zm-x-client-proxy` directory.


## Proxy Rules

1. /               -> <ui_server>
2. /favicon.ico    -> <ui_server>/assets/favicon.ico
3. /@zimbra/<rest> -> <zimbra_server>/<rest>

## Using with zm-docker

You can deploy this as it's own stack into the same swarm that is running [zm-docker](https://github.com/Zimbra/zm-mailbox) by making a few simple tweaks.

Set the `zimbra_server.cfg` as follows:

	zmc-proxy:443


Update the `docker-compose.yml` file as follows. 

**Important!**

Update `zm-docker_default` as shown in the diff to match whatever was created for the stack that you deployed from `zm-docker`.


    $ git diff docker-compose.yml
    diff --git a/docker-compose.yml b/docker-compose.yml
    index aeac96b..8c6019a 100644
    --- a/docker-compose.yml
    +++ b/docker-compose.yml
    @@ -10,6 +10,8 @@ services:
           - haproxy
           - ui_server
           - zimbra_server
    +    networks:
    +      zm-docker_default: {}
         secrets:
           - cert
         entrypoint:
    @@ -26,6 +28,10 @@ configs:
       ui_server:
         file: ./ui_server.cfg
     
    +networks:
    +  zm-docker_default:
    +    external: true
    +
     secrets:
       cert:
         file: ./server.pem



## References

* [How To Implement SSL Termination With HAProxy on Ubuntu 14.04]p(https://www.digitalocean.com/community/tutorials/how-to-implement-ssl-termination-with-haproxy-on-ubuntu-14-04)
* [LetsEncrypt with HAProxy](https://serversforhackers.com/c/letsencrypt-with-haproxy)

