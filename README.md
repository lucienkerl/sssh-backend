# sssh-backend

## Development

There are two ways of running a dev server.
1. Use Docker to setup a MongoDB and NodeJS with all dependencies (recommended way)
2. Setup your MongoDB yourself and manage NodeJS yourself

### Method 1 (Managed by Docker) (recommended way)
#### Requirements
* you need to stop any local mongodb and nodejs servers which listens to the default Mongodb (27017) or the default Nodejs (3000) Port.

* In case you previously had mongodb installed through brew please run the following command:

    ```launchctl remove homebrew.mxcl.mongodb; pkill -f mongod```

#### Start the Docker Containers
Just run: ```npm run dev-docker```. You should now have a MongoDB and NodeJS instance running. Just edit the source code. Nodemon will handle a NodeJS Server restart for you.

### Method 2 (Managed by yourself)

Just start your MongoDB by yourself and run `npm run dev`
