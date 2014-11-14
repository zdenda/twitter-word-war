###

###

http = require("http")

env = process.env.NODE_ENV ? 'test'
config = require("./config.#{env}.json")

server = http.createServer((req, res) ->
  res.writeHead 200,
    "Content-Type": "text/plain; charset=UTF-8"

  res.end "Hello World\n"
)
server.listen config.port

console.log "Server is running at port #{config.port}"
