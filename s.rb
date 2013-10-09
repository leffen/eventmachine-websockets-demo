require 'sinatra'

get '/' do
  @em_port = 3001
  erb :index
end

post '/vote/:state' do
  puts "vote = #{params[:state]} #{request.ip}"
 # puts "request = #{request.inspect}"
  status 200
end