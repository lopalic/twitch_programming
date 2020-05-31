require 'open3'

module TwitchChat
  module Problem
    module Fetcher
      def self.fetch(problem_number)
        # fetch problem
        curl_command = "curl https://projecteuler.net/problem=#{problem_number}"
        _stdin, stdout, _stderr, _wait_thr = Open3.popen3(curl_command)

        # parse only the problem content
        stdout.readlines.map(&:chomp).join('')[/<div class=\"problem_content\" role=\"problem\">(.*?)<\/div>/m]
        to_print = Regexp.last_match(1).gsub(/\/n|<\/?p>/, '')

        # print the output on the screen
        print_command = "tmux send-keys -t chat_session:coding.left \"echo #{to_print}\" Enter"
        Open3.popen3(print_command) do |stdin, stdout, stderr, wait_thr|
          puts stdin
          puts stdout
          puts stderr
          puts wait_thr.pid
        end
      end
    end

    module Checker
      def self.check_solution(problem_number, solution)
        solutions_file = '~/Desktop/solutions.txt'
        lines = File.readlines(File.expand_path(solutions_file)).map(&:chomp)
        lines.include?("#{problem_number}. #{solution}")
      end
    end
  end
end
