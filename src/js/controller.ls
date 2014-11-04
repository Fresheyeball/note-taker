iPhoneHack = ->
  for i in document.querySelectorAll "input[id*='textAngular']" then 
    document.body.removeChild i

@app.controller "controller" ($scope, Socket) ->

  $scope.notes = []
  pure         = title : "", body : ""
  
  $scope.untitled = "Untitled"

  update       = ->
    $scope.notes = it
    $scope.$digest! unless $scope.$$phase
  
  $scope.new    = -> $scope.notes.unshift pure
  $scope.delete = -> $scope.notes = _.pull $scope.notes, $scope.notes[it]

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