require 'rubygems'
require 'sinatra'
require 'json'
require "sinatra/multi_route"

require File.join( File.dirname(__FILE__), 'api.rb')

run DedupApp
