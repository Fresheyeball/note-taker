class MockSocket
  l    : {}
  on   : (k,l) !-> if @l[k] then @l[k].push l else @l[k] = [l]
  emit : (k,d) !-> for l in @l[k] when l then l d 

pure   = title : "", body : ""

describe "Controller" ->

  scope = null
  ms    = null

  beforeEach module "app"

  beforeEach inject ($rootScope, $controller) ->
    scope := $rootScope.$new!
    ms    := new MockSocket!
    $controller "controller" $scope : scope, Socket : ms

  beforeEach -> expect scope.notes .to.be.empty

  specify "notes come over the socket" ->
    ms.emit "update" [pure]
    expect scope.notes .to.not.be.empty
    expect scope.notes .to.deep.equal [pure]

  specify "new note" ->
    ms.on "update" -> expect it .to.deep.equal [pure]
    scope.new!
    expect scope.notes .to.not.be.empty
    expect scope.notes .to.have.length 1
    expect _.first scope.notes .to.deep.equal pure

  specify "set active" ->
    impure = title : "moo", body:"mooo"
    scope.notes = [pure, pure, impure]
    scope.setActive 2 
    expect _.first scope.notes .to.deep.equal impure

  specify "delete" ->
    scope.notes = [pure]
    scope.delete 0
    expect scope.notes .to.be.empty 

