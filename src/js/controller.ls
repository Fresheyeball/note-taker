iPhoneHack = ->
  return unless i = _.first document.querySelectorAll "input[id*='textAngular']"
  document.body.removeChild i
  setTimeout (-> document.body.appendChild i) 200

@app.controller "controller" ($scope, $window, Socket) ->

  $scope.notes = []
  pure         = title : "", body : ""
  
  $scope.untitled = "Untitled"

  update       = ->
    $scope.notes = it
    $scope.$digest! unless $scope.$$phase
  
  $scope.new    = -> $scope.notes.unshift pure
  $scope.delete = ->
    t = _.first $scope.notes .title or $scope.untitled
    if $window.confirm "Are you sure you want to delete " + t + "?"
    then $scope.notes = _.pull $scope.notes, $scope.notes[it]

  $scope.setActive = ->
    a = $scope.notes[it]
    $scope.notes = _.pull $scope.notes, a
    $scope.notes.unshift a 
  
  save         = -> Socket.emit "update" $scope.notes

  Socket.on "update" update

  $scope.$watch "notes" save, true

  $scope.toggleMenu = ->
    iPhoneHack!
    $scope.menu = !$scope.menu