# vim: ts=2 sts=2 sw=2 noet ai

.DEFAULT_GOAL := help

.PHONY: help
help:               ## Show this help message
	@grep -E '^[.a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN { FS = ":.*?## " }; { lines[FNR]=$$1":##"$$2; len=length($$1); if (len > max) max=len; ++c; } END { FS=":##";fmt="\033[36;1m%-"max"s\033[37;1m    %s\033[0m\n"; for(i=1;i<=c;++i){$$0=lines[i]; printf(fmt, $$1, $$2) } }'

.PHONY: prereqs
prereqs:            ## Check for and try to install prerequisites
	@bin/bootstrap.sh

.PHONY: image
image:              ## Build the docker image
	@docker build . --build-arg="REGUSER=$$USER" -f ubuntu-cron.dockerfile -t cs260a-final:latest

.PHONY: start
start:              ## Start the container
	@docker run --rm -d --hostname cs260a-final --name cs260a-final cs260a-final:latest

.PHONY: stop
stop:               ## Stop (destroys) the container
	@docker stop -t0 cs260a-final

.PHONY: ps
ps:                 ## Check if the container is running
	@docker ps -f name=cs260a-final

.PHONY: shell
shell:              ## Open an interactive shell to the container
	@docker exec -it -u "$$USER" cs260a-final /bin/bash -li
