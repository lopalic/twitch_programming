require 'twitch_chat'

describe TwitchChat do
  before do
    # ENV variables stubs
    allow(ENV).to receive(:[]).with('BOT_OAUTH_TOKEN').and_return('fake token')
    allow(ENV).to receive(:[]).with('BOT_USERNAME').and_return('fake name')
    allow(ENV).to receive(:[]).with('CHANNEL').and_return('fake channel')

    allow_any_instance_of(TwitchChat::Listener).to receive(:new)
      .and_call_original
    allow_any_instance_of(TwitchChat::Listener).to receive(:socket)
      .and_return(fake_socket)

    allow_any_instance_of(TCPSocket).to receive(:new).and_return(fake_socket)
  end

  let(:fake_listener) { TwitchChat::Listener.new }
  let(:fake_socket) { instance_double 'TCPSocket' }

  context '#login' do
    it 'sends login into to the socket' do
      expect(fake_socket).to receive(:puts).with('PASS fake token').once
      expect(fake_socket).to receive(:puts).with('NICK fake name').once
      expect(fake_socket).to receive(:puts).with('JOIN #fake channel').once
      fake_listener.login
    end
  end

  context '#listen' do
    before do
      allow_any_instance_of(TwitchChat::Listener).to receive(:login)
    end

    it 'listens for input' do
      expect(fake_socket).to receive(:gets).at_least(:once)
      expect(fake_socket).to receive(:close)
      fake_listener.listen
    end
  end
end
