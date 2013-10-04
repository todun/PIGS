# PGSServer.rb
# Simple HTTP server that routes our PUT requests

require 'rubygems'
require 'webrick'
require File.dirname(__FILE__) + '/PGSRoutes'

if ARGV[0] then
	port = ARGV[0]
else
	port = 9001
end

if $0 == __FILE__ then
	server = WEBrick::HTTPServer.new(:Port=>port)
	server.mount "/", WEBrick::HTTPServlet::FileHandler, './Static/'
	ip = IPSocket.getaddress(Socket.gethostname)
	server.mount "/play", PlayRoute
	server.mount "/control", ControlsRoute
	trap "INT" do
		server.shutdown
	end

	puts "\n===================="
	puts " * PGSServer running at #{ip} on port #{port}"
	puts "====================\n\n"
	
	server.start
end
