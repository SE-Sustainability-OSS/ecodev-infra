# Line 1 to 20 are here to render the help output pretty, not to be read and even less understood!! :)
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)
# From https://gist.github.com/prwhite/8168133#gistcomment-1727513
# Add the following 'help' target to your Makefile
# And add help text after each target name starting with ##
# A category can be added with @category
HELP_DESCRIPTION = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

# If the first argument is "setup-vm"...
ifeq (setup-vm,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "setup-vm"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif


help:		## Show this help.
	@perl -e '$(HELP_DESCRIPTION)' $(MAKEFILE_LIST)

.PHONY: setup-vm
setup-vm:            ##@prod Setup a vanilla ubuntu 2(0-2-4).04 VM
	sh ./setup.sh $(RUN_ARGS)

traefik-launch:            ##@prod Launch traefik production container
	docker compose -f docker-compose.traefik.yml up -d

bookstack-launch:            ##@prod Launch bookstack production containers
	docker compose -f docker-compose.bookstack.yml up -d

db-launch:            ##@prod Launch db production containers
	docker compose -f docker-compose.yml up -d

db-dev-launch:            ##@dev Launch db dev containers
	docker compose up -d

minio-launch:            ##@prod Launch minio production containers
	docker compose -f docker-compose.minio.yml -f docker-compose.minio.override.yml up -d

minio-dev-launch:            ##@dev Launch minio dev containers
	docker compose -f docker-compose.minio.yml up -d

ofelia-launch:            ##@prod Launch ofelia production containers
	docker compose -f docker-compose.ofelia.yml up -d

keycloak-launch:            ##@prod Launch keycloak production containers
	docker compose -f docker-compose.keycloak.yml up -d

pypi-launch:            ##@prod Launch pypi production container
	docker compose -f docker-compose.pypi.yml up -d

