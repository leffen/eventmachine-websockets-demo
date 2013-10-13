require 'thin'
require 'em-websocket'
require 'sinatra/base'
require 'em-redis'
require_relative 'lib/ewd'


module EmTest

  def self.em_channel
    @em_channel ||= EM::Channel.new
  end

  EM_PORT='3001'

  EM.run do

    class App < Sinatra::Base

      def self.save_votes(votes)
        redis = EM::Protocols::Redis.connect
        redis.set("votes", votes.to_json)
      end

      def self.init_votes(votes_json)
        if votes_json && data = JSON.parse(votes_json)
          Ewd::Votes.from_json(data)
        else
          votes = Ewd::Votes.new
          votes.set_question(1, 'Svar JA', 'yes')
        end
      end

      configure do
        redis = EM::Protocols::Redis.connect
        redis.get('votes') do |response|
          set :votes, init_votes(response)
        end
      end

      get '/' do
        @em_port = EM_PORT
        erb :index
      end


      post '/vote/:spm/:state' do
        sum = settings.votes.set_answer(params[:spm], request.ip, params[:state])
        redis = EM::Protocols::Redis.connect
        redis.set("votes", settings.votes.to_json)

        EmTest.em_channel.push({action: :vote_update, spm: params[:spm].to_i, sum: sum}.to_json)
        status 200
      end
    end

    @clients = []

    EM::WebSocket.start(:host => '0.0.0.0', :port => EM_PORT) do |ws|
      ws.onopen do |handshake|
        @clients << ws
        sid = EmTest.em_channel.subscribe { |msg| ws.send msg }
        EmTest.em_channel.push( {action: :msg, data: "Subscriber ID #{sid} connected tp #{handshake.path}!"}.to_json  )
      end

      ws.onclose do
        EmTest.em_channel.push "Closed."
        @clients.delete ws
      end

      ws.onmessage do |msg|
        EmTest.em_channel.push msg
      end
    end

    Thin::Server.start App, '0.0.0.0', 3000
  end
end
