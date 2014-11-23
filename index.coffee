Twit = require("twit")
http = require("http")
fs = require("fs")

utils = require("./utils")

env = process.env.NODE_ENV ? 'test'
config = require("./config.#{env}.json")

counter = 0
lastTweet = null
start = new Date()
history = {}
words = {}
words[word] = {"index": i, "tweets": 0} for word, i in config.words


# increment count of word
incWord = (word, index, interval) ->
  words[word].tweets++
  history[interval] = [] unless history[interval]
  history[interval][i] = (history[interval][i] or 0) + 1

# HTTP server response - data in JSON
sendDataResponse = (res) ->
  response =
    tweets: counter
    start: utils.formatDate(start)
    lastTweet: null
    words: words
    history: history
  if lastTweet?
    response.lastTweet =
      user: lastTweet.user.screen_name
      text: lastTweet.text
  res.writeHead 200,
    "Content-Type": "application/json"
  res.end JSON.stringify(response)

# HTTP server response - index.html
sendIndexResponse = (res) ->
  res.writeHead 200,
    "Content-Type": "text/html; charset=UTF-8"
  fs.createReadStream(__dirname + "/index.html").pipe(res)

# HTTP server response - error 404
sendError404Response = (res) ->
  res.writeHead 404,
    "Content-Type": "text/plain; charset=UTF-8"
  res.end("404 Not Found\n");


twitter = new Twit(config.twitter)
stream = twitter.stream('statuses/filter', { track: config.words })

stream.on 'error', (error) ->
  console.error error

stream.on 'tweet', (tweet) ->
  lastTweet = tweet
  ++counter
  interval = utils.intervalStart(config.interval, utils.parseTwitterDate(tweet.created_at))
  incWord(word, i, interval) for word,i in config.words when utils.search(word, tweet.text)


server = http.createServer((req, res) ->
  switch req.url
    when "/" then sendIndexResponse(res)
    when "/data" then sendDataResponse(res)
    else sendError404Response(res)
)
server.listen config.port

console.log "Server is running at port #{config.port}"
