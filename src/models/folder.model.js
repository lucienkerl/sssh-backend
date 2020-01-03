const mongoose = require('mongoose')

const folderSchema = new mongoose.Schema({
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
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Folder',
    },
  ],
  connections: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Connection',
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

// Helper function for deep population of children and connections
const populateChildrenAndConnections = function(next) {
  this.populate('children').populate('connections')
  next()
}

folderSchema
  .pre('findOne', populateChildrenAndConnections)
  .pre('find', populateChildrenAndConnections)

const Folder = mongoose.model('Folder', folderSchema)

module.exports = Folder
