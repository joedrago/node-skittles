# ---------------------------------------------------------------------------------------
# Required modules

util = require 'util'

# ---------------------------------------------------------------------------------------
# THE BRAAAAAAINS (of the bot)

class Brain
  constructor: (@bot) ->

  react: (channel, who, msg) ->
    delayed = true
    @bot.respond channel, "#{who} said #{msg}", delayed

module.exports = Brain
