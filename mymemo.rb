# frozen_string_literal: true

require 'sinatra'
require 'pg'

CONN = PG.connect(
  host: 'localhost',
  dbname: ENV['MEMO_DB'],
  user: ENV['MEMO_USER'],
  password: ENV['MEMO_PASSWORD']
)

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def load_memos
  memos = CONN.exec('SELECT id, name, body FROM memos ORDER BY name')
  memos.map { |memo| memo.transform_keys(&:to_sym) }
end

def create_memo(new_name:, new_body:)
  CONN.exec_params('INSERT INTO memos (name, body) VALUES ($1, $2)', [new_name, new_body])
end

def select_target_memo(selected_id)
  memos = CONN.exec_params('SELECT id, name, body FROM memos WHERE id = $1', [selected_id])
  memos.map { |memo| memo.transform_keys(&:to_sym) }.first
end

def update_memos(selected_id:, updated_name:, updated_body:)
  CONN.exec_params('UPDATE memos SET name = $1, body = $2 WHERE id = $3', [updated_name, updated_body, selected_id])
end

def delete_target_memo(selected_id)
  CONN.exec_params('DELETE FROM memos WHERE id = $1', [selected_id])
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
