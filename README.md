| Linux                                           |
|-------------------------------------------------|
| [![Build Status][travis_status]][travis_builds] |

[travis_status]: https://travis-ci.org/Mizux/webapp-101.svg?branch=master
[travis_builds]: https://travis-ci.org/Mizux/webapp-101

# Introduction
My repository about FOSS web app development using the Travis-CI infrastructure for
 testing.

### Project directory layout
Thus the project layout is as follow:

* [package.json](package.json) Dependencies list consumed by [npm](https://www.npmjs.com/) and [yarn](https://yarnpkg.com/lang/en/).

## Nodejs Project Build
To run this webapp project, as usual:
```sh
yarn serve
```

## CI: Makefile/Docker testing
To test the build, there is a Makefile using
a [node:alpine](https://hub.docker.com/_/node/) docker containers to test.

To get the help simply type:
```sh
make
```

For example to test the webapp:
```sh
make test
```

# License
Apache 2. See the LICENSE file for details.


# Environment Setup
First things first, let's setting up a native development environment on various GNU/Linux distro or using a docker container.  

You'll need:
- **nodejs**,
- **npm** and
- **yarn**.

note: Look at `docker/Dockerfile` for install script.
