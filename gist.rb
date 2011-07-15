require 'rubygems'
require 'typhoeus'
require 'orthrus'
require 'json'

class Gist
  include Orthrus
  remote_defaults :base_uri   => "http://gist.github.com"

  define_remote_method :index,   :path => "/api/v1/:format/gists/:login",
                                 :on_success => lambda { |r| JSON.parse(r.body)["gists"] }
  define_remote_method :info,    :path => "/api/v1/:format/:gist_id",
                                 :on_success => lambda { |r| JSON.parse(r.body)["gists"].first }
  define_remote_method :content, :path       => "/gist/:gist_id/:filename",
                                 :base_uri   => "https://raw.github.com",
                                 :on_success => lambda { |r| r.body }
end

# Get all gists of xijo
gists         = Gist.index(:login => "xijo", :format => :json)

# Get the first gist
gist_id       = gists.first["repo"]
gist_info     = Gist.info(:gist_id => gist_id, :format => :json)

# Get the gists content
gist_filename = gist_info["files"].first
gist_content  = Gist.content(:gist_id => gist_id, :filename => gist_filename)

# Hydra example
hydra = Typhoeus::Hydra.new
hydra.queue gists_request = Gist.index(:login => "xijo", :format => :json, :return_request => true)
hydra.run
puts gists_request.handled_response.inspect