const mongoose = require('mongoose')
const dbUrl = require('../config/config').mongoDB

mongoose.connect(dbUrl, {
  useNewUrlParser: true,
  useCreateIndex: true,
  useUnifiedTopology: true,
})
