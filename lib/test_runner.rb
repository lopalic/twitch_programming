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
      _stdin, _stdout, _stderr, _wait_thr = Open3.popen3(command)

      capture_output = "tmux capture-pane -p -t chat_session:coding.left"
      _stdin, stdout, _stderr, _wait_thr = Open3.popen3(capture_output)
      # NOTE: the terminal looks something like this:
      # $USER>some>path>
      # <solution>
      # $USER>some>path>
      # so readlines[-2] fits nicely as long as puts variable is used without
      # any other newlines
      solved = TwitchChat::Problem::Checker
               .check_solution(problem_number, stdout.readlines[-2])

      return false unless solved

      writer = TwitchChat::VimWriter.new('~/Desktop/solutions.txt')
      writer.append(problem_number, ' SOLVED')
      solved
    end
  end
end
