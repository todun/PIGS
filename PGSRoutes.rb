# PGSRoutes.rb
# Routes reponsible for playback controls

class PSGRoute

	# Ask the tuner to play a track based on a query string
	class PlayRoute < WEBrick::HTTPServlet::AbstractServlet
		
		def initialize server, tuner
			@tuner = tuner
		end

		def do_PUT(request, reponse)
			if(query = request.query['query'])
				puts "Playing result for query #{query}"
				@tuner.play_song_for_query(query)
			end
		end
	end

	# Ask the tuner to execute a playback command
	class ControlsRoute < WEBrick::HTTPServlet::AbstractServlet
		def do_PUT(request, repsonse)
			@commands = {
				"pause_unpause" => " ",
				"stop" => "q"
			}
			if(tuner_command = request.query['command'])
				if @commands.has_key?(tuner_command)
					puts "Executing command #{tuner_command}"
				else
					puts "Unknown command: #{tuner_command}"
				end
			end
		end
	end
end
