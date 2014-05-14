require 'sinatra/base'
require 'sinatra/respond_with'

class Api < Sinatra::Base
  register Sinatra::RespondWith

  get '/xml_server' do
    doc  = params[:doc]
    sent = params[:s]

    get_file(doc, sent)

    respond_to do |f|
      f.xml { file }
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
