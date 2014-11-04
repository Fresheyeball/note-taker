iPhoneHack = ->
  return unless i = _.first document.querySelectorAll "input[id*='textAngular']"
  document.body.removeChild i
  setTimeout (-> document.body.appendChild i) 200

@app.controller "controller" ($scope, $window, Socket) ->

  $scope.notes = []
  pure         = -> title : "" body : ""
  
  $scope.untitled = "Untitled"

  update       = (d) ->
    $scope.notes = d 
    $scope.$digest! unless $scope.$$phase
  
  $scope.new    = -> $scope.notes.unshift pure!
  $scope.delete = (i) ->
    t = _.first $scope.notes .title or $scope.untitled
    if $window.confirm "Are you sure you want to delete " + t + "?"
    then $scope.notes = _.pull $scope.notes, $scope.notes[i]

  $scope.setActive = (i) ->
    $scope.notes = _.remove($scope.notes, $scope.notes[i]) ++ $scope.notes
  
  save         = -> Socket.emit "update" $scope.notes

  Socket.on "update" update

  $scope.$watch "notes" save, true 

  $scope.toggleMenu = -> iPhoneHack!; $scope.menu = !$scope.menu