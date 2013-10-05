# PGSTuner.rb
# A wrapper around the grooveshark rubygem

require 'grooveshark'
require 'date'

class PGSTuner
	def initialize
		init_grooveshark
		@read_io, @write_io = IO.pipe
	end

	def init_grooveshark
		@init_date = DateTime.now
		@grooveshark_client = Grooveshark::Client.new
		@grooveshark_session = @grooveshark_client.session
	end

	def play_song_for_query(query)
		query.strip!
		songs = @grooveshark_client.search_songs(query)
		song = songs.first
		url = @grooveshark_client.get_song_url(song)

		child = fork do
			puts "child read: #{@read_io} child write: #{@write_io}"
			@write_io.close
			STDIN.reopen(@read_io)
			`mplayer -really-quiet "#{url}"` 
		end
	end

	def execute_tuner_command(command)
		puts "parent read: #{@read_io} parent write: #{@write_io}"
		puts command
		@read_io.close
		@write_io.write "#{command}"
		@write_io.close
	end
end
