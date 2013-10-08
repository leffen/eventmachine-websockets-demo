require 'sinatra'

get '/' do
  @em_port = 3001
  erb :index
end