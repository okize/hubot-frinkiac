chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'hubot-frinkiac', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/frinkiac')(@robot)

  it 'registers a respond listener for "simpsons me <query>"', ->
    expect(@robot.respond).to.have.been.calledWithMatch sinon.match((val) ->
      val.test "simpsons me d'oh!"
    )

  it 'registers a respond listener for "simpsons search <query>"', ->
    expect(@robot.respond).to.have.been.calledWithMatch sinon.match((val) ->
      val.test "simpsons search me fail english?"
    )

  it 'registers a respond listener for "frinkiac <query>"', ->
    expect(@robot.respond).to.have.been.calledWithMatch sinon.match((val) ->
      val.test "frinkiac i'd be stupid not to do this"
    )

  it 'does NOT register a hear listener', ->
    expect(@robot.hear).to.not.have.been.calledWith sinon.match((val) ->
      val.test "simpsons search"
    )

  it 'registers a respond listener for "futurama me <query>"', ->
    expect(@robot.respond).to.have.been.calledWithMatch sinon.match((val) ->
      val.test "futurama me good news, everyone!"
    )

  it 'registers a respond listener for "futurama search <query>"', ->
    expect(@robot.respond).to.have.been.calledWithMatch sinon.match((val) ->
      val.test "futurama search why not zoidberg?"
    )
