# PGSServer.rb
# Simple HTTP server that routes our PUT requests

require 'rubygems'
require 'webrick'
require File.dirname(__FILE__) + '/PGSRoutes'

if $0 == __FILE__ then
	server = WEBrick::HTTPServer.new(:Port=>8000)
	server.mount "/play", PlayRoute
	server.mount "/control", ControlsRoute
	trap "INT" do
		server.shutdown
	end
	server.start
end
