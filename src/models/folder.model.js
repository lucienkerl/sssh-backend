const mongoose = require('mongoose')

const Folder = mongoose.model('Folder', {
  name: {
    type: String,
    required: true,
    trim: true,
  },
  shared: {
    type: Boolean,
    default: false,
    required: true,
  },
  parent: {
    type: mongoose.Schema.Types.ObjectId,
    default: null,
    ref: 'Folder',
  },
  children: [
    {
      child: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Folder',
      },
    },
  ],
  connections: [
    {
      connection: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Connection',
      },
    },
  ],
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: 'User',
  },
  members: [
    {
      member: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User',
      },
    },
  ],
})

module.exports = Folder
