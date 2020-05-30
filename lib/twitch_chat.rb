require 'socket'
require 'lib/vim_writer'
require 'lib/test_runner'

module TwitchChat
  class Listener
    attr_reader :socket, :vim_writer, :test_runner

    def initialize
      @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
      @vim_writer = TwitchChat::VimWriter.new
      @test_runner = TwitchChat::TestRunner.new
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
        when /\!prepend\ (\d+)\ ?(.*)/
          vim_writer.prepend(Regexp.last_match(1), Regexp.last_match(2))
        when /\!append\ (\d+)\ ?(.*)/
          vim_writer.append(Regexp.last_match(1), Regexp.last_match(2))
        when /\!above\ (\d+)\ ?(.*)/
          vim_writer.above(Regexp.last_match(1), Regexp.last_match(2))
        when /\!below\ (\d+)\ ?(.*)/
          vim_writer.below(Regexp.last_match(1), Regexp.last_match(2))
        when /\!rmline\ (\d+)/
          vim_writer.rmline(Regexp.last_match(1))
        when /\!test/
          test_runner.run_test
        else
          next
        end
      end
    ensure
      # don't leave the listener open
      socket.close
    end
  end
end
