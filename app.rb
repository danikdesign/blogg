#encoding: utf-8
require 'sqlite3'
require 'rubygems'
require 'sinatra'v

def init_db
  @db = SQLite3::Database.new 'blogg.db'
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
  erb :new
end

post '/new' do
  @message = params[:message]

  erb "You typed #{@message}"
end