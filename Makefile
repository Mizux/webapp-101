PROJECT := webapp_101
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
SHA1 := $(shell git rev-parse --verify HEAD)
HOST_PORT := 8080

# General commands
.PHONY: help
BOLD=\e[1m
RESET=\e[0m

help:
	@echo -e "${BOLD}SYNOPSIS${RESET}"
	@echo -e "\tmake <target> [NOCACHE=1]"
	@echo
	@echo -e "${BOLD}DESCRIPTION${RESET}"
	@echo -e "\ttest build inside docker containers so we can test against various major distro setup."
	@echo
	@echo -e "${BOLD}MAKE TARGETS${RESET}"
	@echo -e "\t${BOLD}help${RESET}: display this help and exit."
	@echo
	@echo -e "\t${BOLD}docker${RESET}: build a docker devel image."
	@echo -e "\t${BOLD}bash${RESET}: run a container of the devel image for debug purpose."
	@echo
	@echo -e "\t${BOLD}serve${RESET}: run the webapp inside a container."
	@echo
	@echo -e "\t${BOLD}test${RESET}: ${BOLD}test${RESET} using the devel image."
	@echo
	@echo -e "\t${BOLD}clean${RESET}: Remove log files and docker image."
	@echo
	@echo -e "\t${BOLD}NOCACHE=1${RESET}: use 'docker build --no-cache' when building container (default use cache)."
	@echo
	@echo -e "branch: $(BRANCH)"
	@echo -e "sha1: $(SHA1)"

# Need to add cmd_distro to PHONY otherwise target are ignored since they do not
# contain recipe (using FORCE do not work here)
.PHONY: all
all: serve

# Delete all implicit rules to speed up makefile
.SUFFIXES:
# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =
# Keep all intermediate files
# ToDo: try to remove it later
.SECONDARY:

# Docker image name prefix.
IMAGE := ${PROJECT}

ifdef NOCACHE
DOCKER_BUILD_CMD := docker build --no-cache
else
DOCKER_BUILD_CMD := docker build
endif

DOCKER_RUN_CMD := docker run -p ${HOST_PORT}:8080 --rm --init --name ${IMAGE}

# $* stem
# $< first prerequist
# $@ target name

# DOCKER: Build the devel image
.PHONY: docker
docker: cache/docker_devel.tar
cache/docker_devel.tar: docker/Dockerfile package.json
	mkdir -p cache
	@docker image rm -f ${IMAGE}:devel 2>/dev/null
	${DOCKER_BUILD_CMD} -t ${IMAGE}:devel -f $< .
	@rm -f $@
	docker save ${IMAGE}:devel -o $@

# DOCKER BASH: Inspect the devel image (debug)
.PHONY: bash
bash: cache/docker_devel.tar
	${DOCKER_RUN_CMD} -it ${IMAGE}:devel /bin/sh

# DOCKER SERVE: Run the server
.PHONY: serve
serve: cache/docker_devel.tar
	-docker stop ${IMAGE} 2>/dev/null | true
	${DOCKER_RUN_CMD} -d ${IMAGE}:devel

# TEST: Verify server is running
.PHONY: test
test: serve
	@timeout 10 sh -c \
 'until $$(curl --output /dev/null --silent --head --fail localhost:${HOST_PORT}); do \
   echo "."; \
   sleep 1; \
 done'
	@curl -i localhost:${HOST_PORT}
	@docker stop ${IMAGE} 1>/dev/null

# CLEAN
.PHONY: clean
clean:
	docker container prune -f
	docker image prune -f
	-docker image rm -f ${IMAGE}_$*:devel 2>/dev/null
	-rm -f cache/docker_devel.tar
	-rmdir cache
