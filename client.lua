local socket = require("socket")

-- Connect to the server
local client = assert(socket.connect("localhost", 12345))

-- Send a message to the server
client:send("Hello, server!\n")

-- Receive the response from the server
local response, err = client:receive()
if not err then
  print("Received from server: " .. response)
end

-- Close the client socket
client:close()
