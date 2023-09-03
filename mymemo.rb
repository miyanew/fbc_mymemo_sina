# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'
Bundler.require(:default)

MEMO_FILEPATH = 'memos.json'

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

def create_memo(new_name:, new_body:)
  memos = load_memos
  id = SecureRandom.uuid
  memos << { id:, name: new_name, body: new_body }
  save_memos(memos)
end

def select_target_memo(selected_id)
  load_memos.find { |memo| memo[:id] == selected_id }
end

def update_memos(selected_id:, updated_name:, updated_body:)
  updated_memos = load_memos.map do |memo|
    if memo[:id] == selected_id
      memo[:name] = updated_name
      memo[:body] = updated_body
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
  redirect '/memos'
end

get '/memos' do
  @memos = load_memos
  erb :memo_top
end

get '/memos/new' do
  erb :memo_new
end

post '/memos/new' do
  create_memo(new_name: params[:name], new_body: params[:body])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = select_target_memo(params[:id])
  erb :memo_show
end

patch '/memos/:id' do
  update_memos(selected_id: params[:id], updated_name: params[:name], updated_body: params[:body])
  redirect "/memos/#{params[:id]}"
end

get '/memos/:id/edit' do
  @memo = select_target_memo(params[:id])
  erb :memo_edit
end

delete '/memos/:id' do
  delete_target_memo(params[:id])
  redirect '/memos'
end
