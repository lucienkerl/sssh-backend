const express = require('express')
const Connection = require('../models/connection.model')
const Folder = require('../models/folder.model')
const auth = require('../middleware/auth')
const router = new express.Router()

router.post('/connections/:id', auth, async (req, res) => {
  const _id = req.params.id
  const connection = new Connection(req.body)

  try {
    const folder = await Folder.findById(_id)

    if (!folder) {
      throw { message: 'Folder not found' }
    }

    await connection.save()

    folder.connections.push(connection._id)
    await folder.save()

    res.status(201).send(connection)
  } catch (e) {
    res.status(400).send(e)
  }
})

module.exports = router
