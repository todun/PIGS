# PIGSTuner.rb
# A wrapper around the grooveshark rubygem

require 'grooveshark'
require 'thread'
require 'active_support/all'

class PIGSTuner
	def initialize
		init_grooveshark
		@read_io, @write_io = IO.pipe
		@child = nil
		@mutex = Mutex.new
	end

	def init_grooveshark
		puts "Initializing new Grooveshark session"
		@expiration_date = Time.now + (24*60*60)
		@grooveshark_client = Grooveshark::Client.new
		@grooveshark_session = @grooveshark_client.session
	end

	def session_expired?
		return Time.now > @expiration_date
	end

	# Asks Grooveshark for a song url and plays it
	def play_song_with_id(id)
		if @mutex.locked? then
			execute_tuner_command("stop")
		end
		if @mutex.try_lock then
			begin
				url = @grooveshark_client.get_song_url_by_id(id)
				@child = fork do
					STDIN.reopen(@read_io)
					`mplayer -really-quiet "#{url}"`
					@mutex.unlock
				end
			rescue Exception
				return {"success" => false}.to_json
			end
			return {"success" => true}.to_json
		end
		return {"success" => false}.to_json
	end

	# Search for a Grooveshark track
	# Returns a JSON array of the results
	def search(query)
		# Check if we need a new Grooveshark session
		if session_expired?
			init_grooveshark
		end

		query.strip!
		songs = @grooveshark_client.search_songs(query)
		return songs.to_json

	end

	# Searches Grooveshark and plays the first result
	# Returns JSON object of song playing, or nil
	def im_feeling_lucky(query)
		# Check if we need a new Grooveshark session
		if session_expired?
			init_grooveshark
		end

		# Ask Grooveshark for a song
		query.strip!
		songs = @grooveshark_client.search_songs(query)
		song = songs.first

		# If we got a song, play it
		unless song.nil?
			play_song_with_id(song.id)
		end

		return song.to_json
	end

	# Playback controls
	# Returns JSON encoded success message
	def execute_tuner_command(command)
		commands = {
			"pause_unpause" => " ",
			"stop" => "q"
		}
		if commands.has_key?(command)
			@write_io.write "#{commands[command]}"
			return {"success" => true}.to_json
		else
			return {"success" => false}.to_json
		end
	end
end
