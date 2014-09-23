require 'sinatra/base'
require 'sinatra/respond_with'
require 'sinatra/json'
require 'time'
require 'json'

class Api < Sinatra::Base
  register Sinatra::RespondWith

  before do
    headers 'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => %w{ GET },
      'Access-Control-Allow-Headers' => %w{ Content-Type }
  end

  get '/xml_server/:doc' do
    doc  = params[:doc]
    sent = params[:s]

    respond_to do |f|
      f.xml { get_file(doc, sent) }
    end
  end

  get '/comments/:doc' do
    doc = params[:doc]
    json = read_comment_file(doc)
    respond_to do |f|
      f.json { json }
    end
  end

  post '/comments/:doc' do
    res = JSON.parse(request.body.read)
    date = Time.utc(*Time.now.to_a).iso8601(3)

    doc = params[:doc]
    json_comm = JSON.parse(read_comment_file(doc))

    user = "Robert"
    res['created_at'] = date
    res['updated_at'] = date
    res['reason'] = 'general'
    res['user'] = user
    res['comment_id'] = next_comment_id(json_comm)

    json_comm << res.reject { |k, v| k == 'ids' || k == 'sId' }
    write_comment_file(doc, json_comm)

    json(res)
  end

  get '/smyth/:doc' do
    File.read(File.join(DATA_PATH, 'smyth', params[:doc]))
  end

  post '/xml_server/:doc' do
    doc  = params[:doc]
    sent = params[:s]

    respond_to do |f|
      f.xml do
        if post_file(doc, sent, request.body.read)
          content_type :xml
          respond_with(200)
        end
      end
    end
  end

  options '/xml_server/:doc' do
  end

  options '/comments/:doc' do
  end

  DATA_PATH = File.expand_path("../../../data", __FILE__)
  DATA_PATH = File.expand_path("../../../data", __FILE__)

  def current_file(doc, sent)
    path = [doc, sent].compact.join('.')
    "#{DATA_PATH}/#{path}.xml"
  end

  def get_file(doc, sent)
    File.read(current_file(doc, sent))
  end

  def post_file(doc, sent, xml)
    File.open(current_file(doc, sent), 'w')	do |f|
      f.puts(xml)
    end
    # Should do some error handling here
    true
  end

  def comment_path(doc)
    File.join(DATA_PATH, 'comments', "#{doc}.json")
  end

  def read_comment_file(doc)
    File.read(comment_path(doc))
  end

  def write_comment_file(doc, comments)
    comm_str = JSON.pretty_generate(comments, indent: '  ')
    File.write(comment_path(doc), comm_str)
  end

  def next_comment_id(comments)
    ids = comments.map { |comment| comment['comment_id'].to_i }
    ids.max + 1
  end
end
