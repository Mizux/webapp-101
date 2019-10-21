# Create a virtual environment with all tools installed
FROM node:alpine AS env
LABEL maintainer="mizux.dev@gmail.com"
# Install/Configure nodejs, npm, yarn
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
# Global Dependencies
RUN yarn global add @vue/cli

EXPOSE 8080
CMD [ "yarn", "start" ]


# Add the webapp src to our env
FROM env AS devel
# Create app directory
WORKDIR /home/node/app
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
RUN yarn install
# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "yarn", "start" ]


# Create a production image
FROM node:alpine AS prod
LABEL maintainer="mizux.dev@gmail.com"
# Create app directory
WORKDIR /home/node/app
# Copy app from devel to prod
COPY --from=builder /home/node/app/node_modules /home/node/app/

EXPOSE 8080
CMD [ "yarn", "start" ]
