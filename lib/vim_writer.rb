require 'open3'

module TwitchChat
  class VimWriter
    attr_reader :file

    def initialize
      @file = '~/twitch_programs.rb'
    end

    def prepend(line_num, text)
      command = "vim -c \"#{line_num} s/^/#{text}/\" -c \"wq\" #{@file}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
    end

    def append(line_num, text)
      command = "vim -c \"#{line_num} s/$/#{text}/\" -c \"wq\" #{@file}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
    end

    def above(line_num, text)
      command = "vim -c \"#{line_num - 1} s/^/\r#{text}/\" -c \"wq\" #{@file}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
    end

    def below(line_num, text)
      command = "vim -c \"#{line_num} s/$/\r#{text}/\" -c \"wq\" #{@file}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # TODO: remove, for testing purposes
        puts stdin
        puts stdout
        puts stderr
        puts wait_thr.pid
      end
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
    end

    def auto_center(line_num)
      # TODO: implement if needed
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
