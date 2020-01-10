# sssh-backend

## Setup

Just run the following commands to setup your SSSH-Backend Server:

```
wget https://raw.githubusercontent.com/lucienkerl/sssh-backend/master/scripts/sssh.sh && chmod +x sssh.sh
./sssh.sh install
./sssh.sh start
```

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
Just run: 

```cd scripts && ./run.sh start-dev```

You should now have a MongoDB and NodeJS instance running. Just edit the source code. Nodemon will handle a NodeJS Server restart for you. 

___
It may take a few moments until the MongoDB Database is ready. If it doesn't start in time and you get a timeout from NodeJS, just wait until the database is ready (you will get console output about that) and save any file to restart the nodejs process. Then the NodeJS App should reconnect to the MongoDB and everything should work!
___

### Method 2 (Managed by yourself)

Just start your MongoDB by yourself and run `npm run dev`
