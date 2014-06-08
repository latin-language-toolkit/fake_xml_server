require 'sinatra/base'
require 'sinatra/respond_with'

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

  post '/xml_server/:doc' do
    doc  = params[:doc]
    sent = params[:s]

    respond_to do |f|
      f.xml { post_file(doc, sent, request.body.read)}
    end
  end

  options '/xml_server/:doc' do
  end

  DATA_PATH = File.expand_path("../../../data", __FILE__)

  def current_file(doc, sent)
    "#{DATA_PATH}/#{doc}.#{sent}.xml"
  end

  def get_file(doc, sent)
    File.read(current_file(doc, sent))
  end

  def post_file(doc, sent, xml)
    File.open(current_file(doc, sent), 'w')	do |f|
      f.puts(xml)
    end
  end
end
