require! <[ connect serve-static socket.io ]>

app    = connect!.use serve-static __dirname + '/public' .listen 80
notes  = [ title : "Sample Note" body : "Edit me" ]

socket.listen app .sockets.on 'connection' ->
  it.emit "update" notes .on "update" -> notes := it