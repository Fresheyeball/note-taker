require! <[
  connect
  serve-static
  socket.io
]>

app = connect!.use serve-static __dirname + '/public' .listen 8080

data   = {}

socket.listen app .sockets.on 'connection' (s) ->

  s.emit "update" data .on "update" (obj) ->
    data := obj
    s.broadcast.emit "update" data