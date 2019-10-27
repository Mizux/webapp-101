# Introduction
A simple app without using any framework.

# Project directory layout
Thus the project layout is as follow:

* [package.json](package.json) Dependencies list consumed by [npm](https://www.npmjs.com/) and [yarn](https://yarnpkg.com/lang/en/).
* [index.js](index.js) entry point of the application.
* [Makefile](Makefile) Script used to run CI/local test.

# Project Step

## Step 1: Environment Setup
First, setup a native development environment on various GNU/Linux distro
or using the official [node:alpine](https://hub.docker.com/_/node/) docker image.  

You'll need:
- **nodejs**,
- **npm** and
- **yarn**.

note: few distro don't provide a `yarn` package, you might install it using:
```sh
export NPM_CONFIG_PREFIX=${HOME}/.npm-global
export PATH=$PATH:${NPM_CONFIG_PREFIX}/bin

npm install --global yarn
```

note: You can also use the official docker image
[node:alpine](https://hub.docker.com/_/node/).  

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
Let's add [http](https://nodejs.org/api/http.html) as dependency using:
```sh
yarn add http
```

Then install them using:
```sh
yarn install
```

## Step 4: Write our server entry point
Create the file `index.js` and add this content:
```js
'use strict';

const http = require('http');
const port = 8080;

const requestHandler = (request, response) => {
  console.log(request.url)
  response.end('Hello Node.js Server!')
}

const server = http.createServer(requestHandler)

server.listen(PORT, (err) => {
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${PORT}`)
})
```

## Step 5: Launch the webapp
First we will add a [script](https://yarnpkg.com/en/docs/package-json#toc-scripts)
to package.json by adding:
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

To verify the server is responding, you can use:
```sh
curl -i localhost:8080
```

# CI: Makefile/Docker testing
To test the build, there is a Makefile using the [node:alpine](https://hub.docker.com/_/node/) docker image to test.

To get the help simply type:
```sh
make
```

For example to test the webapp:
```sh
make test
```
