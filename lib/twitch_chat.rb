require 'socket'

module TwitchChat
  class Listener
    attr_reader :socket

    def initialize
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
      while (line = socket.gets)
        case line
        when /PING :tmi.twitch.tv/
          socket.puts('PONG :tmi.twitch.tv')
          puts 'Sent PONG response to keep the connection alive...'
        when /\!write\ (.*)/
          puts Regexp.last_match(1)
        when /\!test/
          # TODO: implement running the test actually :D
          puts 'Running the test for this program...'
        else
          puts 'No command detected, regular chat...'
        end

        # TODO: remove later, logging purposes only now
        puts line
      end
    ensure
      # don't leave the listener open
      socket.close
    end
  end
end
