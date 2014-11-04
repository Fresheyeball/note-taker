require! <[
  connect
  serve-static
  socket.io
]>

app    = connect!.use serve-static __dirname + '/public' .listen 80

sample = title : "Sample Note", body : "Edit me"
notes  = [sample]

socket.listen app .sockets.on 'connection' (s) ->

  s.emit "update" notes .on "update" -> notes := it