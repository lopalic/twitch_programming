require 'open3'
require 'lib/problem'
require 'lib/vim_writer'

module TwitchChat
  class TestRunner
    attr_reader :file

    def initialize
      @file = '~/Desktop/twitch_programs.rb'
    end

    def run_test(problem_number)
      command = "tmux send-keys -t chat_session:coding.left \"ruby #{@file}\" Enter"
      _stdin, stdout, _stderr, _wait_thr = Open3.popen3(command)
      # NOTE: does not work properly at the moment
      # stdout is empty :(
      puts stdout.readlines.last
      solved = TwitchChat::Problem::Checker
               .check_solution(problem_number, stdout.readlines.last)

      return false unless solved

      writer = TwitchChat::VimWriter.new
      writer.append(problem_number, 'SOLVED')
      solved
    end
  end
end
