require 'rubygems'
require 'sinatra'
require 'json'
require "sinatra/multi_route"
require "csv"

class DedupApp < Sinatra::Application
  register Sinatra::MultiRoute

  before do
    puts '[Params]'
    p params
    puts '[Body]'
    p request.body
  end

  ## configuration
  configure do
    set :raise_errors, false
    set :show_exceptions, false
  end

  not_found do
    halt 404, {'Content-Type' => 'application/json'}, JSON.generate({ 'error' => 'route not found' })
  end

  error 500 do
    halt 500, {'Content-Type' => 'application/json'}, JSON.generate({ 'error' => 'server error' })
  end

  before do
    headers "Content-Type" => "application/json; charset=utf8"
    headers "Access-Control-Allow-Methods" => "HEAD, GET, POST"
    headers "Access-Control-Allow-Origin" => "*"
    cache_control :public, :must_revalidate, :max_age => 60
  end

  ## routes
  get '/' do
    redirect '/heartbeat'
  end

  get "/heartbeat/?" do
    return JSON.pretty_generate({
      "routes" => [
        "/heartbeat (GET)",
        "/dups (POST)"
      ]
    })
  end

  post '/dups/?' do
    dedup()
    # file_data = params[:myfile]
    # return JSON.pretty_generate({"file": "uploaded!"})
    # @filename = params[:file][:filename]
    # file = params[:file][:tempfile]

    # File.open("/Users/sacmac/#{@filename}", 'wb') do |f|
    #   f.write(file.read)
    # end
  end

  ## prevent some HTTP methods
  route :delete, :put, :copy, :options, :trace, '/*' do
    halt 405
  end

  ## helper functions
  def dedup
    @request_payload = JSON.parse request.body.read
    res = dedup_all(@request_payload)
    return JSON.pretty_generate(res)
  end

  def dedup_all(x)
    gbif_fields = ["institutionCode", "catalogNumber"]
    vertnet_fields = ["institutioncode", "catalognumber"]
    idigbio_fields = ["institutioncode", "catalognumber"]

    # x = JSON.parse(IO.read("/Users/sacmac/github/sac/dedup/test_notpretty.json"))
    gbif = getbykey(x["gbif"], gbif_fields)
    vertnet = getbykey(x["vertnet"], vertnet_fields)
    idigbio = getbykey(x["idigbio"], idigbio_fields)

    find_dups(gbif, vertnet, idigbio)
  end

  # getbykey(out['gbif'], gbif_fields)
  def getbykey(x, fields)
    x.each do |w|
      w.keep_if { |x, y| !x.match(fields.join('|')).nil? }
    end
  end

  # stuff
  def find_dups(x, y, z)
    mappings = {"institutionCode" => "institutioncode", "catalogNumber" => "catalognumber"}
    newgbif = []
    x.each do |z|
      newgbif << Hash[z.map {|k, v| [mappings[k], v] }]
    end
    # institutioncode
    icode_gbif = getvalues(newgbif, 'institutioncode')
    icode_vertnet = getvalues(y, 'institutioncode')
    icode_idigbio = getvalues(z, 'institutioncode')
    icode_comp = icode_gbif & icode_vertnet & icode_idigbio
    # catalognumber
    ccode_gbif = getvalues(newgbif, 'catalognumber')
    ccode_vertnet = getvalues(y, 'catalognumber')
    ccode_idigbio = getvalues(z, 'catalognumber')
    ccode_comp = ccode_gbif & ccode_vertnet & ccode_idigbio

    res = {"dups" => [{"institutioncode_dups" => !icode_comp.empty?},
      {"catalognumber_dups" => !ccode_comp.empty?}]
    }
    return res
  end

  def getvalues(x, y)
    vals = []
    x.each do |z|
      vals << z[y].downcase
    end
    return vals
  end

end
