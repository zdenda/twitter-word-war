###

###

http = require("http")

PORT = 8080

server = http.createServer((req, res) ->
  res.writeHead 200,
    "Content-Type": "text/plain; charset=UTF-8"

  res.end "Hello World\n"
)
server.listen PORT

console.log "Server is running at port #{PORT}"
