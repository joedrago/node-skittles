# ---------------------------------------------------------------------------------------
# Required modules

util = require 'util'

# ---------------------------------------------------------------------------------------
# THE BRAAAAAAINS (of the bot)

class Brain
  constructor: (@nicknames, @bot, @loadCB) ->
    @loadCB() if @loadCB

  react: (channel, who, msg) ->
    delayed = true
    @bot.respond channel, "#{who} said #{msg}", delayed

module.exports = Brain
