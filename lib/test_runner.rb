require 'open3'

module TwitchChat
  class TestRunner
    attr_reader :file

    def initialize
      @file = '~/Desktop/twitch_programs.rb'
    end

    def run_test
      command = "tmux send-keys -t chat_session:coding.left \"ruby #{@file}\" Enter"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
    end
  end
end
