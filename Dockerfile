FROM node:latest
LABEL com.wuerth.product=sssh
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install
RUN npm install -g nodemon
COPY . /usr/src/app
EXPOSE 3000
CMD ["nodemon", "src/index.js"]