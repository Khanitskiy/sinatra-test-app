require 'sinatra'
require "sinatra/json"
require 'redis'
require 'net/http'
require 'pry'

EUR = 1

before do
  @redis = Redis.new
end

get '/' do
  @date = @redis.get('date')
  @currences = JSON.parse(@redis.get('currences')) unless @redis.get('currences').nil?
  setup_data if @date.nil? || @currences.nil?
  erb :index
end

get '/calculate' do
  give_currency = @redis.get(params['give_currency']) || EUR
  get_currency = @redis.get(params['get_currency']) || EUR

  json :result => calculate(give_currency, get_currency, params['give_quantity'])
end

put '/update_date' do
  date = (Time.now - 86400).strftime("%d.%m.%Y")
  actual_date = @redis.get('date') == date

  setup_data unless actual_date

  response_hash = { changed: !actual_date, date: date }
  json response_hash
end

private

def calculate(give_currency, get_currency, quantity)
  in_base_currency = quantity.to_f / give_currency.to_f
  result = (get_currency.to_f * in_base_currency)
  get_currency == @redis.get('base') ? in_base_currency.round(2) : result.round(2)
end

def setup_data
  response_json = get_data
  date = Date.parse(response_json['date'])&.strftime("%d.%m.%Y")

  if @currences.nil?
    @currences = response_json["rates"].map(&:first)
    @redis.set('currences', @currences << 'EUR')
  end

  response_json["rates"].each { |k,v| @redis.set(k,v) }
  @redis.set('base', response_json['base'])
  @redis.set('date', date)
end

def get_data
  uri = URI('https://api.exchangeratesapi.io/latest?base=EUR')
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end