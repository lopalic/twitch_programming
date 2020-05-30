# frozen_string_literal: true

require './env_setup.rb'
require 'lib/twitch_chat'

bot = TwitchChat::Listener.new
bot.listen
