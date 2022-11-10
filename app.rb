#encoding: utf-8
require 'sqlite3'
require 'rubygems'
require 'sinatra'

def init_db
  @db = SQLite3::Database.new 'blogg.db'
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts
  (
    id	INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content	TEXT,
    author TEXT
   )'

  @db.execute 'CREATE TABLE IF NOT EXISTS Comments
  (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content	TEXT,
    author TEXT,
    post_id INTEGER
   )'
end

get '/' do
  @results = @db.execute 'select * from Posts order by id DESC'

  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  @author = params[:author]
  @content = params[:post]

  hh = { :author => 'Type your name', :post => ' Type your post' }

  err = hh.select { |key,_| params[key] == '' }.values.join(',')

  if err != ''
    @error = err

    return erb :new

  else
    @db.execute 'insert into Posts (content, created_date, author) values (?, datetime(), ?)', [@content, @author]

    redirect to '/'
  end

end

get '/details/:post_id' do
  post_id = params[:post_id]

  results = @db.execute 'select * from Posts where id = ?', [post_id]
  @row = results[0]
  @comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

  erb :details
end

post '/details/:post_id' do
  post_id = params[:post_id]
  @comment_content = params[:post]
  @comment_author = params[:author]


  hh = { :post => 'Type your comment', :author => ' Type your name'}
  err = hh.select { |key,_| params[key] == ''}.values.join(',')

  if err != ''
    @err = err
    post_id = params[:post_id]
    results = @db.execute 'select * from Posts where id = ?', [post_id]
    @row = results[0]
    @comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

    erb :details

  else
    @db.execute 'insert into Comments (content, created_date, author, post_id) values (?, datetime(), ?, ?)', [@comment_content, @comment_author, post_id]

    redirect to('/details/' + post_id)
  end

end