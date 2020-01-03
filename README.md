# sssh-backend

## Development

### Requirements
* you need to stop any local mongodb and nodejs servers which listens to the default Mongodb (27017) or the default Nodejs (3000) Port.

* In case you previously had mongodb installed through brew please run the following command:

    ```launchctl remove homebrew.mxcl.mongodb; pkill -f mongod```

### Start server

`npm run dev`

