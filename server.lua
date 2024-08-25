local socket = require("socket")

-- Create a TCP socket and bind it to the local host, at any port
local server = assert(socket.bind("*", 12345))

-- Print local address
local ip, port = server:getsockname()
print("Please connect to " .. ip .. " on port " .. port)

-- Loop forever waiting for clients
while true do
  -- Wait for a connection from any client
  local client = server:accept()
  client:settimeout(10)  -- Timeout after 10 seconds

  -- Receive the line
  local line, err = client:receive()
  
  -- If there's no error, send it back to the client
  if not err then
    client:send("You said: " .. line .. "\n")
  end

  -- Done with the client, close the object
  client:close()
end
