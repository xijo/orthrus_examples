require 'rubygems'
require 'typhoeus'
require 'orthrus'
require 'json'

class Twitter
  include Orthrus
  remote_defaults :on_success => lambda { |response| JSON.parse(response.body) },
                  :on_failure => lambda { |response| puts "error code: #{response.code}"; {} },
                  :base_uri   => "http://api.twitter.com"

  define_remote_method :search, :path   => "/:version/search.json"
  define_remote_method :trends, :path   => "/:version/trends/:time_frame.json"
  define_remote_method :tweet,  :path   => "/:version/statuses/update.json",
                                :method => :post
end

# Get all tweets mentioning pluto
tweets = Twitter.search(:version => 1, :params => {:q => "pluto"})

# Get all current trends
trends = Twitter.trends(:version => 1, :time_frame => :current)

# Submit a tweet. Authentication skipped in example.
Twitter.tweet(:version => 1, :params => {:status => "I #love #planets! :)"})