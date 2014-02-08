mongoose = require("mongoose")
Schema = mongoose.Schema
RoomSchema = new Schema
  key: String
  subject: String
  comments: String
  date: Date

mongoose.model('Room', RoomSchema)
mongoose.connect("mongodb://localhost/ted")
Room = mongoose.model('Room')

RoomSchema.methods =