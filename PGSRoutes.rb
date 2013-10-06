# PGSRoutes.rb
# Routes reponsible for playback controls

class PSGRoutes

	# Ask the tuner to play a track based on a query string
	class LuckyRoute < WEBrick::HTTPServlet::AbstractServlet
		
		def initialize server, tuner
			@tuner = tuner
		end

		def do_POST(request, response)
			result = false
			if(request.body)
				result = @tuner.im_feeling_lucky(request.body)
			end

			response.status = 200
			response['Content-Typle'] = "text/plain"
			if result
				response.body = "success"
			else
				response.body = "failure"
			end
		end
	end

	# Ask the tuner to execute a playback command
	class ControlsRoute < WEBrick::HTTPServlet::AbstractServlet
		
		def initialize server, tuner
			@tuner = tuner
		end

		def do_POST(request, response)
			result = false
			if(request.body)
				result = @tuner.execute_tuner_command(request.body)
			end
			
			response.status = 200
			response['Content-Typle'] = "text/plain"
			if result
				response.body = "success"
			else
				response.body = "failure"
			end
		end
	end
end
