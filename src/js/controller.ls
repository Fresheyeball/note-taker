@app.controller "controller" <[ $scope $window Socket ]> ++ ($, $W, S) ->
  pure         = -> title : "" body : ""

  read  = (f) -> f $.notes
  write = (f) -> $.notes = f $.notes
  write -> []
  
  untitled = $.untitled = "Untitled"
  
  $.new    = -> write -> [pure!] ++ it
  $.delete = (i) -> read -> if $W.confirm "Are you sure you want to delete 
    #{_.first it .title or untitled}?" then _.remove it, it[i]

  $.setActive = (i) -> write -> _.remove( it, it[i] ) ++ it 
  
  S.on "update" (d) -> 
    write -> d
    $.$digest! unless $.$$phase

  $.$watch "notes" (-> read ( S.emit "update" )), true 

  $.toggleMenu = -> $.menu = !$.menu