# build environment
FROM node:13.12.0-alpine as build
LABEL maintainer="Fabian Brash"
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
# do a clean install
RUN npm ci --silent
RUN npm install react-scripts@3.4.3 -g --silent
RUN npm audit fix
COPY . ./
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]