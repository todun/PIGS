# PGSRoutes.rb
# Routes reponsible for playback controls

class PSGRoute

	# Ask the tuner to play a track based on a query string
	class LuckyRoute < WEBrick::HTTPServlet::AbstractServlet
		
		def initialize server, tuner
			@tuner = tuner
		end

		def do_PUT(request, reponse)
			if(query = request.query['query'])
				@tuner.im_feeling_lucky(query)
			end
		end
	end

	# Ask the tuner to execute a playback command
	class ControlsRoute < WEBrick::HTTPServlet::AbstractServlet
		
		def initialize server, tuner
			@tuner = tuner
		end

		def do_PUT(request, repsonse)
			if(command = request.query['command'])
				@tuner.execute_tuner_command(command)
			end
		end
	end
end
