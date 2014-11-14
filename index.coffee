Twit = require("twit")
http = require("http")

env = process.env.NODE_ENV ? 'test'
config = require("./config.#{env}.json")

counter = 0
lastTweet = null
start = new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '') 

twitter = new Twit(config.twitter)
stream = twitter.stream('statuses/filter', { track: config.word })

stream.on 'error', (error) ->
  console.error error

stream.on 'tweet', (tweet) ->
  lastTweet = tweet
  ++counter

server = http.createServer((req, res) ->
  res.writeHead 200,
    "Content-Type": "text/plain; charset=UTF-8"

  res.write "#{counter} tweets mentioned \"#{config.word}\" since #{start} UTC\n\n"
  res.write "Last tweet is from @#{lastTweet.user.screen_name}: \"#{lastTweet.text}\"" if lastTweet?
  res.end()
)
server.listen config.port

console.log "Server is running at port #{config.port}"
