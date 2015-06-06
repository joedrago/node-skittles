fs = require 'fs'
util = require 'util'

Skittles = require './skittles'

main = ->

  # default settings are built into Skittles, so nothing will be passed in if a settings file isn't found.
  settings = {}

  if fs.existsSync("settings.json")
    util.log "Reading settings.json"
    settings = JSON.parse(fs.readFileSync("settings.json"))
  else
    util.log "settings.json not found, using defaults"

  skittles = new Skittles(settings)

module.exports =
  main: main
