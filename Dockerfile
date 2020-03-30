# stage1: Specify the base image and tag is as 'builder <any-name>'
FROM node:alpine as builder

# Specify working directory
WORKDIR '/app'

# COPY package json
COPY package.json .

# install dependencies
RUN npm install

# COPY source files
COPY ./ ./

# run npm build to build prod version of app
RUN npm run build

# stage2: Use ngnix to server the build folder contents
# Specify the FROM command to start new stage.
# One phase/stage/block can have only ONE FROM statement
FROM nginx

# COPY the generated build folder from stage1 to the predefined
# directory /usr/share/ngnix/html in ngnix image
# https://hub.docker.com/_/nginx
# after docker build .
# docker run -p 8000:80 container id.
# 80 id default nginx port.
COPY --from=builder /app/build /usr/share/nginx/html
