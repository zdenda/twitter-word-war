Twit = require("twit")
http = require("http")

utils = require("./utils")

env = process.env.NODE_ENV ? 'test'
config = require("./config.#{env}.json")

counter = 0
lastTweet = null
start = new Date()
history = {}

twitter = new Twit(config.twitter)
stream = twitter.stream('statuses/filter', { track: config.word })

stream.on 'error', (error) ->
  console.error error

stream.on 'tweet', (tweet) ->
  lastTweet = tweet
  ++counter
  interval = utils.intervalStart(config.interval, utils.parseTwitterDate(tweet.created_at))
  history[interval] = (history[interval] or 0) + 1

server = http.createServer((req, res) ->
  response =
    tweets: counter
    start: utils.formatDate(start)
    lastTweet: null
    history: history

  if lastTweet?
    response.lastTweet =
      user: lastTweet.user.screen_name
      text: lastTweet.text

  res.writeHead 200,
    "Content-Type": "application/json"
  res.end JSON.stringify(response)
)
server.listen config.port

console.log "Server is running at port #{config.port}"
