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

## References

* [How To Implement SSL Termination With HAProxy on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-implement-ssl-termination-with-haproxy-on-ubuntu-14-04)
* [LetsEncrypt with HAProxy](https://serversforhackers.com/c/letsencrypt-with-haproxy)

