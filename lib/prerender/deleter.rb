require 'redis'

def delete_old_cache_for_host(host)
  r = Redis.new
  ks = r.keys("prerender:#{host}:*")
  unless ks.empty?
    r.del(*ks)
  end
end
