$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'rake'
require 'prerender/searcher'
require 'prerender/deleter'

task :delete, [:host] do |t, args|
  unless args.host.nil?
    puts "Deleting prerenders for #{args.host}"
    delete_old_cache_for_host(args.host)
  end
end

task :record, [:host] do |t, args|
  unless args.host.nil?
    puts "Recording prerenders for #{args.host}"
    start_search("#{args.host}/")
  end
end

task :clean_record, [:host] do |t, args|
  Rake::Task[:delete].invoke(args.host)
  Rake::Task[:record].invoke(args.host)
end
