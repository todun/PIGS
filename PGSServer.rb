# PGSServer.rb
# Simple HTTP server that routes our PUT requests

require 'rubygems'
require 'webrick'
require File.dirname(__FILE__) + '/PGSTuner'
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
	tuner = PGSTuner.new
	server.mount "/lucky", PSGRoutes::LuckyRoute, tuner
	server.mount "/control", PSGRoutes::ControlsRoute, tuner
	trap "INT" do
		server.shutdown
	end

	puts "\n===================="
	puts " * PGSServer running at #{ip} on port #{port}"
	puts "====================\n\n"

	server.start
end
