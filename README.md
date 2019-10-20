| Linux                                           |
|-------------------------------------------------|
| [![Build Status][travis_status]][travis_builds] |

[travis_status]: https://travis-ci.org/Mizux/webapp-101.svg?branch=master
[travis_builds]: https://travis-ci.org/Mizux/webapp-101

# Introduction
My repository about FOSS web app development using the Travis-CI infrastructure for
 testing.

# Project directory layout
Thus the project layout is as follow:

* [package.json](package.json) Dependencies list consumed by [npm](https://www.npmjs.com/) and [yarn](https://yarnpkg.com/lang/en/).
* [Makefile](Makefile) Script used to run CI/local test.

# CI: Makefile/Docker testing
To test the build, there is a Makefile using a [node:alpine](https://hub.docker.com/_/node/) docker containers to test.

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


# Project

## Step 1: Environment Setup
First things first, let's setting up a development environment using a docker container.  

You'll need:
- **nodejs**,
- **npm** and
- **yarn**.

note: Look at [docker/Dockerfile](docker/Dockerfile) for install script.

## Step 2: Create a new project

Simply run the following command and fill the form:
```sh
yarn init
```

You should have something like this
```sh
$ yarn init
yarn init v1.19.1
question name (webapp-101): 
question version (1.0.0): 
question description: webapp test
question entry point (index.js): 
question repository url (git@github.com:Mizux/webapp-101.git): 
question author (Mizux Seiha <mizux.dev@gmail.com>): 
question license (MIT): Apache-2.0
question private: 
success Saved package.json
Done in 78.63s.
```

## Step 3: Add Dependencies
Let's add few development and production dependencies using:
```sh
yarn add --dev ...
```

## Step 4: Install Dependencies
Let's install them using:
```sh
yarn install
```

## Step 5: Launch the webapp
First we will add a [script](https://yarnpkg.com/en/docs/package-json#toc-scripts) to package.json by adding:
```json
{
  "scripts": {
    "start": "node index.js"
  }
}
```

Then to run this webapp project, you can use:
```sh
yarn start
```
