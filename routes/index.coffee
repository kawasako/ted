
#
# * GET home page.
#
exports.index = (req, res) ->
  # console.log req.session.test
  # req.session.test = "toppage"
  res.render "index",
    title: "toppage"

# mongo
# mongoose = require("mongoose")
# Schema = mongoose.Schema;
# RoomSchema = new Schema
#   subject: String
#   key: String
#   date: Date
# mongoose.model('Room', RoomSchema)
# mongoose.connect("mongodb://localhost/ted")
# Room = mongoose.model('Room')


# post create
exports.create = (req, res) ->
  roomKey = createKey()

  # save db
  # room = new Room()
  # room.subject = req.body.subject
  # room.key = roomKey
  # room.date = new Date()

  # room.save (err)->
  #   console.log 'save-----------'
  #   if err
  #     console.log 'SAVE DB ERROR!!!'
  #     console.log err
  #   else
  #     Room.find (err, docs)->
  #       console.log docs
  #       true

  # connect
  console.log "already: #{io.namespaces.hasOwnProperty("/#{roomKey}")}"
  if !io.namespaces.hasOwnProperty("/#{roomKey}")
    io.of("/#{roomKey}").on "connection", (socket) ->
      # posted message
      socket.on "message", (data) ->
        # submit message
        io.of("/#{roomKey}").in('hogehoge').emit "message", data
        console.log io.sockets.clients('hogehoge')

      # lack message
      socket.on "reqLackMessage", (obj) ->
        io.of("/#{roomKey}").socket(obj.sid).emit "reqMessage", { list: obj.list, sid: socket.id }

      # return req message
      socket.on "returnMessage", (obj) ->
        io.of("/#{roomKey}").socket(obj.sid).emit "message", { messages: obj.data, sid: socket.id }

      # disconnect
      socket.on "disconnect", ->
        console.log "disconnect"

      socket.on "subscribe", (data) ->
        console.log "aaaaaaaaaaaaaaaaaaa--------------"
        socket.join(data.room)
        console.log "bbbbbbbbbbbbbbbbbb--------------"

      socket.on "unsubscribe", (data) ->
        socket.leave(data.room)

  # res
  res.render "create",
    title: "createdRooms"
    key: roomKey

# exports.rooms = (req, res) ->
#   # io.of("/#{req.params.key}").on "connection", (socket) ->
#   #   console.log "#{key} connection"
#   #   socket.on "message", (data)->
#   #     io.of("/#{key}").emit "message",
#   #       value: data.value
#   res.render "rooms",
#     title: "Express #{req.params.key}"
#     key: req.params.key


exports.finish = (req, res) ->
  res.render "finish",
    title: "Express"
