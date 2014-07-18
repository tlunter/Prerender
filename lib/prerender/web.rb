require 'uri'
require 'digest'

require 'sinatra'
require 'capybara'
require 'capybara/poltergeist'
require 'redis'

module Prerender
  class Web < Sinatra::Application
    c = Capybara::Session.new(:poltergeist)
    r = Redis.new

    get "/favicon.ico" do
      puts "Trapping favicon request"
      ""
    end

    get %r{/(.*)} do |l|
      l = l.gsub(/^(http|https):\/(\w+)/, '\1://\2')
      link = URI.parse(l)
      puts "Got request for #{link.to_s}"
      md5summer = Digest::MD5.new
      md5sum = md5summer.hexdigest link.to_s

      key = "prerender:#{link.host}:#{md5sum}"

      if r.exists key
        r.hget key, :body
      else
        puts "Visiting: #{link.to_s}"
        c.visit(link.to_s)
        sleep(2.0)
        c.body.tap do |b|
          puts "Setting #{key}"
          r.hmset key, :uri, link.to_s, :body, b
        end
      end
    end
  end
end
