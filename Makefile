DOCKER_STACK_NAME ?= zm-docker-proxy

all: setup build

build:
	@docker-compose build

.PHONY: clean

clean: down
	@echo "Removing ui_server.cfg, zimbra_server.cfg, server.pem"
	@rm -f ui_server.cfg
	@rm -f zimbra_server.cfg
	@rm -f server.pem
	@rm -f zm-x-client-proxy.*
	@rm -f key.pem

down:
	docker stack rm '${DOCKER_STACK_NAME}'
	@rm -f .up.lock

logs: up
	docker logs proxy

up: .up.lock

.up.lock:
	docker stack deploy -c docker-compose.yml '${DOCKER_STACK_NAME}'	
	touch .up.lock

.ssl-certificate: 
	@echo "Generating self-signed SSL development certificate"
	openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
	    -subj "/C=US/ST=NY/L=Buffalo/O=Synacor/CN=zm-x-client-proxy.local" \
	    -keyout zm-x-client-proxy.key  -out zm-x-client-proxy.cert
	cat zm-x-client-proxy.key zm-x-client-proxy.cert > server.pem

ui_server.cfg:
	@touch $@

zimbra_server.cfg:
	@touch $@

.ui-server: ui_server.cfg

.api-server: zimbra_server.cfg

config: .ssl-certificate .ui-server .api-server

setup: config
	@echo "\nUpdate the following files:"
	@echo "'zimbra_server.cfg' with the target Zimbra SOAP server hostname"
	@echo "'ui_server.cfg' with the target Zimbra X Client server hostname"



