require 'thin'
require 'em-websocket'
require 'sinatra/base'


module EmTest

  def self.em_channel
    @em_channel ||= EM::Channel.new
  end

  EM_PORT='3001'

  EM.run do

    class App < Sinatra::Base
      get '/' do
        @em_port = EM_PORT
        erb :index
      end

      get '/msg/:msg' do
        EmTest.em_channel.push params[:msg]
        status 200
      end

    end

    @clients = []

    EM::WebSocket.start(:host => '0.0.0.0', :port => EM_PORT) do |ws|
      ws.onopen do |handshake|
        @clients << ws
        sid = EmTest.em_channel.subscribe{|msg| ws.send msg}
        EmTest.em_channel.push "Subscriber ID #{sid} connected tp #{handshake.path}!"
      end

      ws.onclose do
        EmTest.em_channel.push "Closed."
        @clients.delete ws
      end

      ws.onmessage do |msg|
        EmTest.em_channel.push msg
      end
    end

    #App.run! :bind=>'0.0.0.0',:port => 3000
    Thin::Server.start App, '0.0.0.0', 3000
  end
end
