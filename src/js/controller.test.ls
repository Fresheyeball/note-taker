class MockSocket
  on   : (k,l) ~~> if @[k] then @[k] ++ l else @[k] = [l]
  emit : (k,d) ~~> for l in @[k] when l then l d

class MockConfirm
  set     : (@_res) ->
  confirm : -> @_res it 

pure   = title : ""    body : ""
impure = title : "moo" body : "mooo"

describe "Controller" ->

  scope = null
  ms    = null
  w     = null

  beforeEach module "app"

  beforeEach inject ($rootScope, $controller) ->
    scope := $rootScope.$new!
    ms    := new MockSocket!
    w     := new MockConfirm!
    $controller "controller" $scope : scope, $window : w, Socket : ms

  beforeEach -> expect scope.notes .to.be.empty

  specify "notes come over the socket" ->
    ms.emit "update" [pure]
    
    expect scope.notes .to.not.be.empty
    expect scope.notes .to.deep.equal [pure]

  describe "new note" ->

    specify "unshifts" ->
      ms.on "update" -> expect it .to.deep.equal [pure]
      scope.new!
      
      expect scope.notes .to.not.be.empty
      expect scope.notes .to.have.length 1
      expect _.first scope.notes .to.deep.equal pure

    specify "s are always a copy" ->
      scope.new!
      scope.new!

      expect scope.notes .to.deep.equal [pure, pure]

      scope .notes[1] .title += "wowzers"
      
      expect scope.notes[0].title .to.equal pure.title
      expect scope.notes[1].title .to.equal "wowzers"

  specify "set active" ->    
    scope.notes = [pure, pure, impure]
    
    scope.setActive 2 
    expect _.first scope.notes .to.deep.equal impure
    
    scope.setActive 0
    expect _.first scope.notes .to.deep.equal impure

    scope.setActive 1 
    expect _.first scope.notes .to.deep.equal pure

  describe "delete" ->

    beforeEach -> scope.notes = [pure]

    specify "pure" ->
      w.set (m) ->
        expect m .to.deep.equal "Are you sure you want to delete Untitled?"
      scope.delete 0

    specify "impure" ->
      w.set (m) ->
        expect m .to.deep.equal "Are you sure you want to delete moo?"
      scope.notes = [impure]
      scope.delete 0 

    specify "true" ->
      w.set -> true
      scope.delete 0
      expect scope.notes .to.be.empty

    specify "false" ->
      w.set -> false
      scope.delete 0 
      expect scope.notes .to.not.be.empty
      expect scope.notes .to.deep.equal [pure]
