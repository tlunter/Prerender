require 'uri'
require 'sinatra'
require 'capybara'
require 'capybara/poltergeist'
require 'pry'

class Prerender < Sinatra::Application
  c = Capybara::Session.new(:poltergeist)
  get '/' do
    unparsed_uri = params["url"] || ""
    begin
      uri = URI.parse(unparsed_uri)
    rescue URI::Error => ex
      puts ex
      return ""
    end

    return "" unless uri.host

    c.visit(uri.to_s)
    sleep(0.12)
    c.body
  end
end
