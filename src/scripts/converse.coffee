# Allows Hubot to talk back. Passive script.

class Messages
  constructor: (@robot) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.messages
        @cache = @robot.brain.data.messages

  nextMessageNum: ->
    maxMessageNum = if @cache.length then Math.max.apply(Math,@cache.map (n) -> n.num) else 0
    maxMessageNum++
    maxMessageNum

  add: (messageText) ->
    message = {num: @nextMessageNum(), message: messageText}
    @cache.push message
    @robot.brain.data.messages = @cache
    message

  all: -> @cache

  random: -> @cache[(Math.random() *  @nextMessageNum() - 1) >> 0]

  buildRandomMessage: ->
    amountOfMessages = ((Math.random() * 3) >> 0) + 2

    message = while amountOfMessages -= 1
      messageParts =  @random().message.split(" ")
      startingPoint = (Math.random() * messageParts.length) >> 0
      messageParts[startingPoint...messageParts.length].join(" ")

    message.join(" ").replace(/((\.|\!|\?)*)(?!$)/,'')



module.exports = (robot) ->
  messages = new Messages(robot)

  robot.hear /(.*)/i, (msg) ->
    message = messages.add msg.match[1]

    if messages.nextMessageNum() > 100
      if ((Math.random() * 50) >> 0) == 1
        msg.send messages.buildRandomMessage()

