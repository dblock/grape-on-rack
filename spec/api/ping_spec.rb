require 'spec_helper'

describe Acme::API do
  include Rack::Test::Methods

  def app
    Acme::API
  end

  before(:all) do
    # warm up 
    get '/api/ping'
    @stats = OStats.new filters: ['Grape'], suppress_nodelta: true,
      trace_allocations: true
    @stats.collect!
  end

  after(:all) do
    GC.start
    @stats.collect!
    @stats.display
  end

  it 'ping' do
    10.times do
      get '/api/ping'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ ping: 'pong' }.to_json)
    end
  end
end
