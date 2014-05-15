require 'sinatra/base'
require 'sinatra/respond_with'

class Api < Sinatra::Base
  register Sinatra::RespondWith

  before do
    headers 'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => %w{ GET }
  end

  get '/xml_server/:doc' do
    doc  = params[:doc]
    sent = params[:s]

    respond_to do |f|
      f.xml { get_file(doc, sent) }
    end
  end

  post '/xml_server' do
    #doc  = params[:doc]
    #sent = params[:sent]

    # tdb
  end

  DATA_PATH = File.expand_path("../../../data", __FILE__)

  def get_file(doc, sent)
    File.read("#{DATA_PATH}/#{doc}.#{sent}.xml")
  end
end
