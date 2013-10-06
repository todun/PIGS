# PGSServer.rb
# Simple HTTP server that routes our PUT requests

require 'rubygems'
require 'webrick'
require File.dirname(__FILE__) + '/PIGSTuner'
require File.dirname(__FILE__) + '/PIGSRoutes'

if ARGV[0] then
	port = ARGV[0]
else
	port = 9001
end

if $0 == __FILE__ then
	server = WEBrick::HTTPServer.new(:Port=>port)
	server.mount "/", WEBrick::HTTPServlet::FileHandler, './www/'
	ip = IPSocket.getaddress(Socket.gethostname)
	tuner = PIGSTuner.new
	server.mount "/lucky", PIGSRoutes::LuckyRoute, tuner
	server.mount "/control", PIGSRoutes::ControlsRoute, tuner
	trap "INT" do
		server.shutdown
	end

	puts "\n===================="
	puts " * PIGSServer running at #{ip} on port #{port}"
	puts "====================\n\n"

	server.start
end
