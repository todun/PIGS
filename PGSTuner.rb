# PGSTuner.rb
# A wrapper around the grooveshark rubygem

require 'grooveshark'

class PGSTuner
	def initialize
		init_grooveshark
		@read_io, @write_io = IO.pipe
		@child = nil
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

	def play_song_for_query(query)

		# Stop currently playing song
		execute_tuner_command("stop")

		# Check if we need a new Grooveshark session
		if session_expired?
			init_grooveshark
		end

		query.strip!
		songs = @grooveshark_client.search_songs(query)
		song = songs.first
		url = @grooveshark_client.get_song_url(song)

		@child = fork do
			STDIN.reopen(@read_io)
			puts "Playing result for query: #{query}"
			puts "#{url}"
			`mplayer -really-quiet "#{url}"` 
		end
	end

	def execute_tuner_command(command)
		commands = {
			"pause_unpause" => " ",
			"stop" => "q"
		}
		if commands.has_key?(command)
			puts "Executing command: #{command}"
			@write_io.write "#{commands[command]}"
		else
			puts "Unknown command: #{command}"
		end
	end
end
