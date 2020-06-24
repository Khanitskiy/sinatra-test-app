require 'rubygems'
require 'bundler'

Bundler.require

set :root, File.dirname('./app')
set :views, Proc.new { File.join(root, "app/views") }

require_all 'app'
run Sinatra::Application