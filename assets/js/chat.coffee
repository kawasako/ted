# Model

class RoomModel
  constructor: (data)->
    @id = data.id
    @name = data.name
    @users = data.users
    @profile = {}
    @log = data.log
    @init()

  init: ->
    for l in @log
      console.log "#{l.user}:#{l.body}（#{l.date}）"

class ProfileModel
  constructor: (data)->
    @id = data.id
    @sid = data.sid
    @name = data.name
    @pos = data.pos
    @date = new Date()

class MessageModel
  constructor: (data)->
    @user = data.user
    @body = data.body
    @date = new Date()


# Controller

class MessageController
  constructor: ->
    @socket = new io.connect("ws://#{document.location.host}/#{window.Room.id}")
    @socket.emit "subscribe", { room: 'hogehoge' }

    @listenEvent()
    setTimeout =>
      for l in window.Room.log
        $(window).trigger "receive", "#{l.user} : #{l.body}（#{l.date}）"
    ,500

  listenEvent: ->
    @socket.on "message", @receiveMessage
    $(window).on
      "message::send": (event, body)=>
        @sendMessage(body)

  sendMessage: (body)->
    message = new MessageModel
      user: window.Room.profile.id
      id: window.Room.profile.id
      body: body
    @socket.emit "message", message

  receiveMessage: (data)->
    window.Room.log.push(data)
    localStorage.setItem("ted#{window.roomKey}", JSON.stringify(window.Room))
    $(window).trigger "receive", "#{data.user} : #{data.body}（#{data.date}）"


# View

class MessageView
  constructor: ->
    $(window).on
      keypress: (e)->
        if 13 == e.keyCode
          $(window).trigger "message::send", $('#messageBox').val()
          $('#messageBox').val('')
      receive: (e, data)->
        $("#result").append "<li>#{data}</li>"




$ ->
  localData = JSON.parse(localStorage.getItem("ted#{window.roomKey}"))
  roomData = if localData then localData else { id: window.roomKey, name: "room name", users: [], log: [] }
  window.Room = new RoomModel(roomData)
  window.Room.profile = new ProfileModel
    id: $("#nameBox").val()
    sid: ""
    name: "unknown"
    pos: { X:0, Y:0 }
  window.MessageController = new MessageController()
  window.MessageView = new MessageView()

# if window.WebSocket
#   socket = new io.connect("ws://#{document.location.host}/#{window.roomKey}")
# else
#   alert '接続できませんでした。'
#   return

# # set data
# window.uid = document.getElementById('nameBox').value
# window.room = JSON.parse(localStorage.getItem("ted#{window.roomKey}"))
# if !window.room
#   window.room = {}
#   window.room.users = {}
# if !window.room.users[window.uid]
#   window.room.users[window.uid] =
#     messages: {}
#     pos: {x:0, y:0}
# for name,val of window.room.users
#   for key, message of val.messages
#     console.log "#{name}:#{message.value}（#{message.date}）"

# $ ->
#   $(window).on
#     keypress: (e)->
#       if 13 == e.keyCode
#         sendMessage $('#messageBox').val()
#         $('#messageBox').val('')

# # メッセージを送る
# sendMessage = (message)->
#   obj =
#     id: Object.keys(window.room.users[window.uid].messages).length
#     user: window.uid
#     value: message
#     date: new Date()
#   socket.emit "message", obj

# # 受け取ったメッセージの保存
# saveMessage = (message, sid)->
#   console.log "------"
#   if !window.room.users[message.user]
#     window.room.users[message.user] =
#       messages: {}
#       pos: {x:0, y:0}
#   window.room.users[message.user].messages[message.id] =
#     value: message.value
#     date: message.date
#   undefoundMessages = []
#   for i in [0..parseInt(message.id)]
#     if !window.room.users[message.user].messages[i]
#       undefoundMessages.push i
#   if 0 < undefoundMessages.length
#     getLackMessage(sid, undefoundMessages)

#   localStorage.setItem("ted#{window.roomKey}", JSON.stringify(window.room))

# # メッセージを受ける
# receiveMessage = (obj)->
#   for message in obj.messages
#     saveMessage(message, obj.sid)
#     console.log "#{message.user}:#{message.value}（#{message.date}）"

# # 足りないメッセージをリクエストする
# getLackMessage = (sid, list)->
#   obj = { sid: sid, list: list }
#   socket.emit "reqLackMessage", obj

# # リクエストされたメッセージを返す
# returnMessage = (obj)->
#   messages = []
#   for i in obj.list
#     message = window.room.users[window.uid].messages[i]
#     if !message
#       message = { value: false, date: false }
#     message.id = i
#     message.user = window.uid
#     messages.push message
#   obj = { data: messages, sid: obj.sid }
#   socket.emit "returnMessage", obj

# # 切断する
# disConnect = ->
#   msg = socket.socket.transport.sessid + "は切断しました。"
#   socket.emit "message",
#     value: msg
#   socket.disconnect()

# socket.on "connect", (message) ->
#   console.log "connect"
#   console.log socket.socket.transport.sessid
#   console.log socket.socket.transport.name

# socket.on "message", receiveMessage
# socket.on "reqMessage", returnMessage
