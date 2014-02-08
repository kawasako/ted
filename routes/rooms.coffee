exports.show = (req, res) ->

  req.session.userId = createKey() if !req.session.userId

  res.render "rooms",
    title: "Room #{req.params.key}"
    userId: req.session.userId
    key: req.params.key