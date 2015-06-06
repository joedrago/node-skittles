irc = require 'irc'
util = require 'util'

defaultSettings =
  host: 'localhost'
  port: 6667
  nicknames: ['Skittles']
  channels: ['#test']

class Skittles
  constructor: (@settings) ->
    # Use default values for anything not offered via @settings.
    for name, value of defaultSettings
      if not @settings.hasOwnProperty(name)
        @settings[name] = value

    util.log "using settings:\n" + JSON.stringify(@settings, null, 2)
    @createClient()

  createClient: ->
    @client = new irc.Client @settings.host, @settings.nicknames[0], {
      channels: @settings.channels
    }

module.exports = Skittles
