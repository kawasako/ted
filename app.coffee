
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
rooms = require("./routes/rooms")
user = require("./routes/user")
http = require("http")
ws = require("websocket.io")
socketIO = require("socket.io")
path = require("path")
MongoStore = require('connect-mongo')(express)
mongoose = require("mongoose")
assets = require("connect-assets")

app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.use assets()
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.cookieParser("ted")
app.use express.session
  secret: "ted"
  store: new MongoStore
    db: 'ted'
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")
app.get "/", routes.index
app.post "/create", routes.create
app.get "/room/:key", rooms.show
app.get "/finish", routes.finish
app.get "/users", user.list

# server
server = http.createServer(app)
server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
global.io = socketIO.listen(server)

# ck
global.createKey = (n=12, b='-_')->
  b = b or ""
  a = "abcdefghijklmnopqrstuvwxyz" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789" + b
  a = a.split("")
  s = ""
  i = 0
  while i < n
    s += a[Math.floor(Math.random() * a.length)]
    i++
  return s

