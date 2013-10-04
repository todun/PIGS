class PlayerRoute < WEBrick::HTTPServlet::AbstractServlet
	def do_PUT(request, reponse)
		play_track(request)
	end

	def play_track(request)
		if(requested_track = request.query['query'])
			puts "playing track #{requested_track}"
		end
	end
end
