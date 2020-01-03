const bcrypt = require('bcryptjs')
const mongoose = require('mongoose')

const connectionSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  address: {
    type: String,
    required: true,
    trim: true,
  },
  port: {
    type: Number,
    default: 22,
  },
  username: {
    type: String,
    trim: true,
  },
  password: {
    type: String,
  },
  isFavorite: {
    type: Boolean,
    default: false,
  },
})

connectionSchema.pre('save', async function(next) {
  const connection = this

  if (connection.isModified('password')) {
    connection.password = await bcrypt.hash(connection.password, 8)
  }

  next()
})

const Connection = mongoose.model('Connection', connectionSchema)

module.exports = Connection
