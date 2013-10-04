# Routes reponsible for playback controls

class PlayRoute < WEBrick::HTTPServlet::AbstractServlet
	def do_PUT(request, reponse)
		if(requested_track = request.query['query'])
			puts "playing track #{requested_track}"
		end
	end
end

class ControlsRoute < WEBrick::HTTPServlet::AbstractServlet
	def do_PUT(request, repsonse)
		if(control_command = request.query['command'])
			if control_command == 'pause'
				puts "pause"
			elsif control_command == 'stop'
				puts "stop"
			elsif control_command == 'resume'
				puts "resume"
			elsif control_command == 'restart'
				puts "restart"
			else
				puts "Unknown command: #{control_command}"
			end
		end
	end
end
