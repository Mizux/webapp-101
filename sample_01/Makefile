PROJECT := webapp_01
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
	@echo -e "\t${BOLD}build_env${RESET}: build a virtual env image."
	@echo -e "\t${BOLD}run_env${RESET}: run a container using the virtual env image (debug purpose)."
	@echo
	@echo -e "\t${BOLD}build_devel${RESET}: build a webapp devel image."
	@echo -e "\t${BOLD}run_devel${RESET}: run a container using the devel image (debug purpose)."
	@echo -e "\t${BOLD}start_devel${RESET}: run the webapp inside a devel image container."
	@echo -e "\t${BOLD}test_devel${RESET}: auto test using the devel image."
	@echo
	@echo -e "\t${BOLD}build_prod${RESET}: build a webapp production image."
	@echo -e "\t${BOLD}run_prod${RESET}: run a container using the production image (debug purpose)."
	@echo -e "\t${BOLD}start_prod${RESET}: run the webapp inside a production image container."
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
MAKEFLAGS += --no-builtin-rules
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


#######
# ENV #
#######
# Build the env image.
.PHONY: build_env
build_env: cache/docker_env.tar
cache/docker_env.tar: docker/Dockerfile
	mkdir -p cache
	@docker image rm -f ${IMAGE}:env 2>/dev/null
	${DOCKER_BUILD_CMD} --target=env -t ${IMAGE}:env -f $< .
	@rm -f $@
	docker save ${IMAGE}:env -o $@

# Run a container using the env image.
.PHONY: run_env
run_env: cache/docker_env.tar
	${DOCKER_RUN_CMD} -it ${IMAGE}:env /bin/sh


#########
# DEVEL #
#########
# Build the devel image.
.PHONY: build_devel
build_devel: cache/docker_devel.tar
cache/docker_devel.tar: docker/Dockerfile cache/docker_env.tar package.json index.js
	mkdir -p cache
	@docker image rm -f ${IMAGE}:devel 2>/dev/null
	${DOCKER_BUILD_CMD} --target=devel -t ${IMAGE}:devel -f $< .
	@rm -f $@
	docker save ${IMAGE}:devel -o $@

# Run a container using the devel image.
.PHONY: run_devel
run_devel: cache/docker_devel.tar
	${DOCKER_RUN_CMD} -it ${IMAGE}:devel /bin/sh

# Run the webapp inside the devel image.
.PHONY: start_devel
start_devel: cache/docker_devel.tar
	-docker stop ${IMAGE} 2>/dev/null | true
	${DOCKER_RUN_CMD} -d ${IMAGE}:devel

# Verify server is running.
.PHONY: test_devel
test_devel: start_devel
	@timeout 10 sh -c \
 'until $$(curl --output /dev/null --silent --head --fail localhost:${HOST_PORT}); do \
   echo "."; \
   sleep 1; \
 done'
	@curl -i localhost:${HOST_PORT}
	@docker stop ${IMAGE} 1>/dev/null


########
# PROD #
########
# Build the prod image.
.PHONY: build_prod
build_prod: cache/docker_prod.tar
cache/docker_prod.tar: docker/Dockerfile cache/docker_devel.tar
	mkdir -p cache
	@docker image rm -f ${IMAGE}:prod 2>/dev/null
	${DOCKER_BUILD_CMD} --target=prod -t ${IMAGE}:prod -f $< .
	@rm -f $@
	docker save ${IMAGE}:prod -o $@

# Run a container using the prod image.
.PHONY: run_prod
run_prod: cache/docker_prod.tar
	${DOCKER_RUN_CMD} -it ${IMAGE}:prod /bin/sh

# Run the webapp inside the prod image.
.PHONY: start_prod
start_prod: cache/docker_prod.tar
	-docker stop ${IMAGE} 2>/dev/null | true
	${DOCKER_RUN_CMD} -d ${IMAGE}:prod


#########
# CLEAN #
#########
.PHONY: clean
clean:
	docker container prune -f
	docker image prune -f
	-docker image rm -f ${IMAGE}:env 2>/dev/null
	-docker image rm -f ${IMAGE}:devel 2>/dev/null
	-docker image rm -f ${IMAGE}:prod 2>/dev/null
	-rm -f cache/docker_env.tar
	-rm -f cache/docker_devel.tar
	-rm -f cache/docker_prod.tar
	-rmdir cache

.PHONY: distclean
distclean: clean
	-docker container rm -f $$(docker container ls -aq)
	-docker image rm -f $$(docker image ls -aq)
