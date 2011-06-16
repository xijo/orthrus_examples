require 'rubygems'
require 'typhoeus'
require 'orthrus'
require 'json'

class OpenLibrary
  include Orthrus
  remote_defaults :on_success => lambda {|response| JSON.parse(response.body)},
    :on_failure => lambda {|response| puts "error code: #{response.code}"},
    :base_uri => "http://openlibrary.org/api"

  define_remote_method :book, :path => '/books'
end

book = OpenLibrary.book(:params => {:bibkeys => "ISBN:0451526538", :format => "json"})

puts book.inspect