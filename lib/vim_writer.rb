require 'open3'

module TwitchChat
  class VimWriter
    attr_reader :file

    def initialize(file = '~/Desktop/twitch_programs.rb')
      @file = file
    end

    def prepend(line_num, text)
      command = "vim -c \"#{line_num} s/^/#{text.chomp}/\" -c \"wq\" #{@file}"
      puts command
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
      auto_center(line_num)
    end

    def append(line_num, text)
      command = "vim -c \"#{line_num} s/$/#{text.chomp}/\" -c \"wq\" #{@file}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
      auto_center(line_num)
    end

    def above(line_num, text)
      command = "vim -c \"#{line_num.to_i - 1} s/$/\r#{text.chomp}/\" -c \"wq\" #{@file}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
      auto_center(line_num)
    end

    def below(line_num, text)
      command = "vim -c \"#{line_num} s/$/\r#{text.chomp}/\" -c \"wq\" #{@file}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
      auto_center(line_num)
    end

    def rmline(line_num)
      command = "vim -c \"#{line_num} g/.*/d\" -c \"wq\" #{@file}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
      auto_center(line_num)
    end

    def auto_center(line_num)
      reload_vim = 'tmux send-keys -t chat_session:coding.right \":e\" Enter'
      refocus = "tmux send-keys -t chat_session:coding.right \"#{line_num}zz\" Enter"
      Open3.popen3(reload_vim) { |stdin, stdout, stderr, wait_thr| }
      Open3.popen3(refocus) { |stdin, stdout, stderr, wait_thr| }
    end

    def start_over
      command = "echo '' > #{@file}"
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
