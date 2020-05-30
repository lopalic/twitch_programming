require 'socket'
require 'lib/vim_writer'

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
        when /\!preped\ (\d+)\ ?(.*)/
          # TODO: do the prepend
        when /\!append\ (\d+)\ ?(.*)/
          # TODO: do the append
        when /\!above\ (\d+)\ ?(.*)/
          # TODO: do the insert above
        when /\!below\ (\d+)\ ?(.*)/
          # TODO: do the insert below
        when /\!rmline\ (\d+)/
          # TODO: do the insert below
        when /\!start_over/
          # TODO: do the insert below
        when /\!test/
          # TODO: implement running the test actually :D
          puts 'Running the test for this program...'
        else
          puts 'No command detected, regular chat...'
        end
      end
    ensure
      # don't leave the listener open
      socket.close
    end
  end
end
