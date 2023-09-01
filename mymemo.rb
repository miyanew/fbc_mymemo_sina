# frozen_string_literal: true

require 'sinatra'
require 'json'

set :environment, :production
MEMO_FILEPATH = 'memos.json'

before do
  content_type 'text/html'
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def load_memos
  if File.exist?(MEMO_FILEPATH)
    JSON.parse(File.read(MEMO_FILEPATH), symbolize_names: true)
  else
    []
  end
end

def save_memos(memos)
  File.write(MEMO_FILEPATH, JSON.pretty_generate(memos))
end

def create_memo(user_response)
  memos = load_memos
  id = Time.now.strftime('%Y%m%d%H%M%S%L')
  memos << { id:, name: user_response[:name], body: user_response[:body] }
  save_memos(memos)
end

def select_target_memo(selected_id)
  load_memos.find { |memo| memo[:id] == selected_id }
end

def update_memos(user_response)
  updated_memos = load_memos.map do |memo|
    if memo[:id] == user_response[:id]
      memo[:name] = user_response[:name]
      memo[:body] = user_response[:body]
    end
    memo
  end
  save_memos(updated_memos)
end

def delete_target_memo(selected_id)
  deleted_memos = load_memos.delete_if { |memo| memo[:id] == selected_id }
  save_memos(deleted_memos)
end

get '/' do
  @memos = load_memos
  erb :memo_top
end

get '/memo' do
  content_type 'text/html'
  erb :memo_new
end

post '/memo' do
  create_memo(params)
  redirect '/'
end

get '/memo/:id' do
  @memo = select_target_memo(params[:id])
  erb :memo_show
end

patch '/memo/:id' do
  update_memos(params)
  redirect "/memo/#{params[:id]}"
end

get '/draft/:id' do
  @memo = select_target_memo(params[:id])
  erb :memo_draft
end

delete '/trash/:id' do
  delete_target_memo(params[:id])
  redirect '/'
end
