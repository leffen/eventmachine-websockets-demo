require 'sinatra'
require 'redis'
require 'json'
require_relative 'lib/ewd'

def get_votes
  r = Redis.new
  votes_json = r.get('votes')
  if votes_json &&  data = JSON.parse(votes_json)
    puts "Loading votes from json #{votes_json}"
    Ewd::Votes.from_json(votes_json)
  else
    votes = Ewd::Votes.new
    votes.set_question(1,'Svar JA','yes')
    votes
  end
end

def save_votes(votes)
  r = Redis.new
  r.set("votes",votes.to_json)
end



configure do
  set :votes, get_votes
end


get '/' do
  @em_port = 3001
  erb :index
end

post '/vote/:spm/:state' do
  puts "spm=#{params[:spm]} vote = #{params[:state]} #{request.ip}"
  sum = settings.votes.set_answer(params[:spm],request.ip,params[:state])
  save_votes settings.votes
  puts "sum yes no = #{sum}"
  status 200
end