# frozen_string_literal: true

require 'sinatra'
require 'json'

set :environment, :production

before do
  content_type 'text/html'
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def load_memos
  memo_filepath = 'memos.json'
  if File.exist?(memo_filepath)
    JSON.parse(File.read(memo_filepath), symbolize_names: true)
  else
    []
  end
end

def save_memos(memos)
  memo_filepath = 'memos.json'
  File.write(memo_filepath, JSON.pretty_generate(memos))
end

def create_memo
  memos = load_memos
  id = memos.empty? ? 1 : memos.map { |memo| memo[:id].to_i }.max + 1
  memos << { id:, name: params[:name], body: params[:body] }
  save_memos(memos)
end

def select_target_memo
  load_memos.find { |memo| memo[:id] == params[:id].to_i }
end

def update_memos
  updated_memos = load_memos.map do |memo|
    if memo[:id] == params[:id].to_i
      memo[:name] = params[:name]
      memo[:body] = params[:body]
    end
    memo
  end
  save_memos(updated_memos)
end

def delete_target_memo
  deleted_memos = load_memos.delete_if { |memo| memo[:id] == params[:id].to_i }
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
  create_memo
  redirect '/'
end

get '/memo/:id' do
  @memo = select_target_memo
  erb :memo_show
end

patch '/memo/:id' do
  update_memos
  redirect "/memo/#{params[:id]}"
end

get '/draft/:id' do
  @memo = select_target_memo
  erb :memo_draft
end

delete '/trash/:id' do
  delete_target_memo
  redirect '/'
end
