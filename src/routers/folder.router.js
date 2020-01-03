const express = require('express')
const auth = require('../middleware/auth')
const Folder = require('../models/folder.model')

const router = new express.Router()

router.post('/folders', auth, async (req, res) => {
  const folder = new Folder({
    ...req.body,
    owner: req.user._id,
  })

  try {
    await folder.save()
    res.status(201).send(folder)
  } catch (e) {
    res.status(400).send(e)
  }
})

router.post('/folders/:id', auth, async (req, res) => {
  const _id = req.params.id

  const folder = new Folder({
    ...req.body,
    parent: _id,
    owner: req.user._id,
  })

  try {
    const parentFolder = await Folder.findById(_id)

    if (!parentFolder) {
      throw { message: 'Parent folder not found' }
    }

    await folder.save()

    parentFolder.children.push(folder._id)
    await parentFolder.save()

    res.status(201).send(folder)
  } catch (e) {
    console.log(e)
    res.status(400).send(e)
  }
})

router.get('/folders', auth, async (req, res) => {
  try {
    const folders = await Folder.find({
      $and: [
        { parent: null },
        { $or: [{ owner: req.user._id }, { 'members.member': req.user._id }] },
      ],
    })

    res.send(folders)
  } catch (e) {
    res.status(500).send()
  }
})

module.exports = router
