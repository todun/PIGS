# PIGSRoutes.rb
# Routes reponsible for playback controls

class PIGSRoutes

	# Ask the tuner to play a track based on a query string
	class LuckyRoute < WEBrick::HTTPServlet::AbstractServlet
		
		def initialize server, tuner
			@tuner = tuner
		end

		def do_POST(request, response)
			lucky_result = nil
			if(request.body)
				lucky_result = @tuner.im_feeling_lucky(request.body)
			end

			unless lucky_result.nil?
				response.status = 200
				response['Content-Type'] = "application/json"
				response.body = lucky_result
			else
				response.status = 400
			end
		end
	end

	class PlayRoute < WEBrick::HTTPServlet::AbstractServlet

		def initialize server, tuner
			@tuner = tuner
		end

	end

	# Get search results from the tuner
	class SearchRoute < WEBrick::HTTPServlet::AbstractServlet

		def initialize server, tuner
			@tuner = tuner
		end

		def do_POST(request, response)
			search_results = nil
			if(request.body)
				search_results = @tuner.search(request.body)
			end

			unless search_results.nil?
				response.status = 200
				response['Content-Type'] = "application/json"
				response.body = search_results
			else
				response.status = 400
			end
		end
	end

	# Ask the tuner to execute a playback command
	class ControlsRoute < WEBrick::HTTPServlet::AbstractServlet
		
		def initialize server, tuner
			@tuner = tuner
		end

		def do_POST(request, response)
			control_result = nil
			if(request.body)
				control_result = @tuner.execute_tuner_command(request.body)
			end
			
			unless control_result.nil?
				response.status = 200
				response['Content-Type'] = "application/json"
				response.body = control_result
			else
				response.status = 400
			end
		end
	end
end
