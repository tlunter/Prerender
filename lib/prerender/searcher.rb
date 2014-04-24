require 'excon'
require 'nokogiri'

def search_document(uri, contents, previous_links)
  document = Nokogiri::HTML(contents)
  document.xpath('//a/@href').each do |a|
    next_uri = URI.parse(a)
    if next_uri.host == nil && next_uri.scheme == nil
      next_uri.host = uri.host
      next_uri.scheme = uri.scheme
      unless previous_links.include? next_uri
        puts "Getting #{next_uri}"
        puts "Already seen: #{previous_links.map(&:to_s)}"
        get_document(next_uri, previous_links)
      end
    end
  end
end

def get_document(uri, previous_links)
  previous_links << uri 
  resp = Excon.get("#{uri.to_s}?_escaped_fragment_=")
  search_document(uri, resp.body, previous_links)
end

def start_search(link)
  uri = URI.parse(link)
  get_document(uri, [])
end
