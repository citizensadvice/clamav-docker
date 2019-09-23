#!/usr/bin/ruby
# frozen_string_literal: true

require 'socket'

eicar = 'X5O!P%@AP[4\PZX54(P^)7CC)7}' \
        '$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'

hostname = ARGV[0]
port = ARGV[1]

begin
  socket = TCPSocket.new(hostname, port)
  socket.send("zINSTREAM\0", 0)

  socket.send([eicar.length].pack('N'), 0)
  socket.send(eicar, 0)

  socket.send([0].pack('N'), 0)
  socket.send('', 0)

  response = socket.gets
  socket.close

  puts response

  if response.include?('FOUND')
    puts "A virus was found: #{response}"
  else
    puts 'No virus was found'
  end
end
