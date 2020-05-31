require 'socket'
require 'lib/vim_writer'
require 'lib/test_runner'
require 'lib/problem'

module TwitchChat
  class Listener
    attr_reader :socket, :vim_writer, :test_runner
    attr_accessor :problem_number

    def initialize
      @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
      @vim_writer = TwitchChat::VimWriter.new
      @test_runner = TwitchChat::TestRunner.new
      @problem_number = nil
    end

    def login
      puts 'Sending credentials.'
      # IRC chat login procedure
      socket.puts("PASS #{ENV['BOT_OAUTH_TOKEN']}")
      socket.puts("NICK #{ENV['BOT_USERNAME']}")
      # join channel
      socket.puts("JOIN ##{ENV['CHANNEL']}")
    end

    def find_first_unsolved
      solutions_file = '~/Desktop/solutions.txt'
      lines = File.readlines(File.expand_path(solutions_file)).map(&:chomp)
      lines.reject { |line| line[/SOLVED/] }.first[/^(\d+)/]
      @problem_number = Regexp.last_match(1)
    end

    def listen
      login
      find_first_unsolved
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
          if test_runner.run_test(problem_number)
            puts 'SOLVED!'
            find_first_unsolved

            # reset editor
            vim_writer.start_over

            # print the new problem
            TwitchChat::Problem::Fetcher.fetch(problem_number)
          end
        when /\!problem/
          TwitchChat::Problem::Fetcher.fetch(problem_number)
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
