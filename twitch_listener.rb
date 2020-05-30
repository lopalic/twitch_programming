require 'socket'

class TwitchListener
  attr_reader :logger, :socket

  # initialize the listener on twitch IRC server
  def initialize()
    @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
  end

  def login
    puts 'Sending credentials.'
    # IRC chat login procedure
    socket.puts("PASS #{ENV['BOT_OAUTH_TOKEN']}")
    socket.puts("NICK #{ENV['BOT_USERNAME']}")

    socket.puts("JOIN ##{ENV['CHANNEL']}")
  end

  def listen
    login

    # log whatever is in the chat
    while line = socket.gets
      puts line
    end

  ensure
    # don't leave the listener open
    socket.close
  end
end

# TODO: move to a separate script, this will be a module later on
bot = TwitchListener.new()

bot.listen
