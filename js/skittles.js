// Generated by CoffeeScript 1.9.3
(function() {
  var Brain, Skittles, defaultSettings, irc, util;

  irc = require('irc');

  util = require('util');

  Brain = require('./brain');

  defaultSettings = {
    host: 'localhost',
    port: 6667,
    nicknames: ['Skittles'],
    channels: ['#test']
  };

  Skittles = (function() {
    function Skittles(settings) {
      var name, value;
      this.settings = settings;
      for (name in defaultSettings) {
        value = defaultSettings[name];
        if (!this.settings.hasOwnProperty(name)) {
          this.settings[name] = value;
        }
      }
      util.log("using settings:\n" + JSON.stringify(this.settings, null, 2));
      this.createBrain();
      this.createClient();
    }

    Skittles.prototype.createBrain = function(cb) {
      return this.brain = new Brain(this.settings.nicknames, this, cb);
    };

    Skittles.prototype.createClient = function() {
      var event, i, len, ref, results;
      this.client = new irc.Client(this.settings.host, this.settings.nicknames[0], {
        channels: this.settings.channels
      });
      ref = ['Join', 'Part', 'Quit', 'Kick', 'Message', 'Error'];
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        event = ref[i];
        results.push(this.client.addListener(event.toLowerCase(), this['on' + event].bind(this)));
      }
      return results;
    };

    Skittles.prototype.onJoin = function(channel, nick, message) {
      if (nick === this.settings.nicknames[0]) {
        util.log("Joining " + channel);
        return this.client.say(channel, "ohai");
      } else {
        return util.log(nick + " joins " + channel);
      }
    };

    Skittles.prototype.onPart = function(channel, nick, reason, message) {
      if (nick === this.settings.nicknames[0]) {
        util.log("Leaving " + channel);
        return this.client.say(channel, 'ohai');
      } else {
        return util.log(nick + " left " + channel);
      }
    };

    Skittles.prototype.onQuit = function(nick, reason, channels, message) {
      if (nick === this.settings.nicknames[0]) {
        util.log("Leaving " + channel);
        return this.client.say(channel, "ohai");
      } else {
        return util.log(nick + " left " + channel);
      }
    };

    Skittles.prototype.onKick = function(channel, nick, bywhom, reason, message) {
      util.log(nick + " was kicked by " + bywhom + " from " + channel + ": " + reason);
      if (nick === this.settings.nicknames[0]) {
        return setTimeout((function(_this) {
          return function() {
            return _this.client.join(channel);
          };
        })(this), 1000);
      }
    };

    Skittles.prototype.onMessage = function(from, to, message) {
      util.log(from + ' => ' + to + ': ' + message);
      if (from !== this.settings.nicknames[0]) {
        this.brain.react(to, from, message);
      }
      if (to === this.settings.nicknames[0]) {
        if (message === 'reload') {
          return this.createBrain((function(_this) {
            return function() {
              return _this.respond(from, "Reloaded.", false);
            };
          })(this));
        }
      }
    };

    Skittles.prototype.onError = function(error) {
      return util.error('error: ' + error);
    };

    Skittles.prototype.wtf = function() {
      return util.log("wtf");
    };

    Skittles.prototype.respond = function(to, message, delayed) {
      var ms;
      if (delayed == null) {
        delayed = true;
      }
      ms = 0;
      if (delayed) {
        ms = 1000;
      }
      util.log("Respond (" + ms + " ms) [" + to + "]: " + message);
      return setTimeout((function(_this) {
        return function() {
          return _this.client.say(to, message);
        };
      })(this), ms);
    };

    return Skittles;

  })();

  module.exports = Skittles;

}).call(this);
