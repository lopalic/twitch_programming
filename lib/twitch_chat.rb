require 'socket'

module TwitchChat
  class Listener
    attr_reader :socket

    # initialize the listener on twitch IRC server
    def initialize()
      @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
    end

    def login
      puts 'Sending credentials.'
      # IRC chat login procedure
      socket.puts("PASS #{ENV['BOT_OAUTH_TOKEN']}")
      socket.puts("NICK #{ENV['BOT_USERNAME']}")
      # join channel
      socket.puts("JOIN ##{ENV['CHANNEL']}")
    end

    def listen
      login
      # log whatever is in the chat
      while line = socket.gets
        # keep the listener alive
        if line =~ /PING :tmi.twitch.tv/
          socket.puts("PONG :tmi.twitch.tv")
          puts 'Sent PONG response to keep the connection alive...'
        end
        puts line
      end

    ensure
      # don't leave the listener open
      socket.close
    end
  end
end
