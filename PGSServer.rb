require 'rubygems'
require 'webrick'
require File.dirname(__FILE__) + '/PlayerRoute'

if $0 == __FILE__ then
	server = WEBrick::HTTPServer.new(:Port=>8000)
	server.mount "/play", PlayerRoute
	trap "INT" do
		server.shutdown
	end
	server.start
end
