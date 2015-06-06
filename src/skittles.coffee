# ---------------------------------------------------------------------------------------
# Required modules

irc = require 'irc'
util = require 'util'
Brain = require './brain'

# ---------------------------------------------------------------------------------------
# Defaults

defaultSettings =
  host: 'localhost'
  port: 6667
  nicknames: ['Skittles']
  channels: ['#test']

# ---------------------------------------------------------------------------------------
# Top-level class. Owns a client and a Brain.

class Skittles
  constructor: (@settings) ->
    # Use default values for anything not offered via @settings.
    for name, value of defaultSettings
      if not @settings.hasOwnProperty(name)
        @settings[name] = value

    util.log "using settings:\n" + JSON.stringify(@settings, null, 2)
    @createBrain()
    @createClient()

  createBrain: ->
    @brain = new Brain(this)

  createClient: ->
    @client = new irc.Client @settings.host, @settings.nicknames[0], {
      channels: @settings.channels
    }
    for event in ['Join', 'Part', 'Quit', 'Kick', 'Message', 'Error']
      @client.addListener event.toLowerCase(), this['on'+event].bind(this)

  onJoin: (channel, nick, message) ->
    if nick == @settings.nicknames[0]
      util.log "Joining " + channel
      @client.say channel, "ohai"
    else
      util.log nick + " joins " + channel

  onPart: (channel, nick, reason, message) ->
    if nick == @settings.nicknames[0]
      util.log "Leaving " + channel
      @client.say channel, 'ohai'
    else
      util.log nick + " left " + channel

  onQuit: (nick, reason, channels, message) ->
    if nick == @settings.nicknames[0]
      util.log "Leaving " + channel
      @client.say channel, "ohai"
    else
      util.log nick + " left " + channel

  onKick: (channel, nick, bywhom, reason, message) ->
    util.log "#{nick} was kicked by #{bywhom} from #{channel}: #{reason}"
    if nick == @settings.nicknames[0]
      setTimeout(=>
        @client.join channel
      , 1000)

  onMessage: (from, to, message) ->
    util.log from + ' => ' + to + ': ' + message
    if from != @settings.nicknames[0]
      @brain.react(to, from, message)

  onError: (error) ->
    util.error 'error: ' + error

  wtf: ->
    util.log "wtf"

  respond: (to, message, delayed = true) ->
    ms = 0
    if delayed
      ms = 1000

    util.log "Respond (#{ms} ms) [#{to}]: #{message}"
    setTimeout(=>
      @client.say to, message
    , ms)

module.exports = Skittles
