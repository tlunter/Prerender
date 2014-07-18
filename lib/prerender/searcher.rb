require 'excon'
require 'nokogiri'

def search_document(conn, contents, previous_links)
  document = Nokogiri::HTML(contents)
  document.xpath('//a/@href').each do |a|
    puts "Found: #{a}"
    next_uri = URI.parse(a)
    if next_uri.host == nil && next_uri.scheme == nil
      unless previous_links.include? next_uri
        puts "Getting #{next_uri}"
        puts "Already seen: #{previous_links.map(&:to_s)}"
        get_document(conn, next_uri, previous_links)
      end
    end
  end
end

def get_document(conn, uri, previous_links)
  previous_links << uri 

  if uri.query.to_s.empty?
    query = "_escaped_fragment_="
  else
    query << "&_escaped_fragment_="
  end

  resp = conn.request(path: uri.path, query: query)
  search_document(conn, resp.body, previous_links)
end

def start_search(link)
  base_uri = URI.parse(link)

  conn = Excon::Connection.new({
    :host       => base_uri.host,
    :port       => base_uri.port,
    :scheme     => base_uri.scheme,
    :method     => "get"
  })

  uri = URI.parse("/")

  get_document(conn, uri, [])
end
