require 'rubygems'
require 'typhoeus'
require 'orthrus'
require 'json'

class Wikipedia
  include Orthrus
  remote_defaults :on_success => lambda {|response| JSON.parse(response.body)},
    :base_uri => "http://en.wikipedia.com/w"

  define_remote_method :index, :path => '/api.php'
end

article = Wikipedia.index(:params => {:action => "query", :titles => "Mars", :format => "json", :prop => "info"})

puts article.inspect
