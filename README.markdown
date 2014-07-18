# Prerender

Have a JS heavy front-end? Want to cache all those pages for search engines?  Using [prerender_rails](https://github.com/prerender/prerender_rails) and this gem, you can.

## Setup

In your Rack application, set up the middleware:

    use Rack::Prerender, prerender_service_url: 'http://prerender.example.com'

and then run your Prerender server at that URL with `unicorn` and `nginx`.

### Requirements

redis

## How it works

The `prerender_rails` middleware verifies when a search engine crawler has hit your URL, and makes a request to `http://prerender.example.com/http://example.com`.
The URL is pulled out of the path and passed to Capybara.
Capybara loads the website, lets the JS execute, and stores the result in Redis.

Since the first execution would be slow, we can pre-cache that execution using the Rake tasks.

`rake clean_record[http://example.com]` will find the root path, and locate all links from there.
It will traverse each link, never hitting the same one twice until it runs out of URLs.
If your site is dynamic with a lot of content, this will take a long time.
For simple sites with not too many routes, it shouldn't be more than 15-20 seconds.

Now all responses for search engine crawlers are cached and quick.
