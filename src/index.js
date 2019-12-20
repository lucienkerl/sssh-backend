const express = require('express')
require('./db/mongoose')
const folderRouter = require('./routers/folder.router')
const userRouter = require('./routers/user.router')

const app = express()
const port = 3000

app.use(express.json())
app.use(folderRouter)
app.use(userRouter)

app.listen(port, () => {
  console.log(`Server is up on port ${port}`)
})
