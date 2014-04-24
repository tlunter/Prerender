require 'uri'
require 'sinatra'
require 'capybara'
require 'capybara/poltergeist'
require 'pry'

class Prerender < Sinatra::Application
  c = Capybara::Session.new(:poltergeist)
  get %r{/(.*)} do |link|
    link = link.gsub(/^(http|https):\/(\w+)/, '\1://\2')
    c.visit(link.to_s)
    sleep(0.12)
    c.body
  end
end
