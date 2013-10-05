# PGSTuner.rb
# A wrapper around the grooveshark rubygem

require 'grooveshark'
require 'date'

class PGSTuner
	def initialize
		@init_date = DateTime.now
		@grooveshark_client = Grooveshark::Client.new
		@grooveshark_session = @grooveshark_client.session
		@read_io, @write_io = IO.pipe
	end

	def play_song_for_query(query)
		query.strip!
		songs = @grooveshark_client.search_songs(query)
		song = songs.first
		url = @grooveshark_client.get_song_url(song)

		child = fork do
		  @write_io.close
		  STDIN.reopen(@read_io)
		  `mplayer -really-quiet "#{url}"`
		end
	end

	def execute_tuner_command(command)
		@read_io.close
		@write_io.write "#{command}"
		@write_io.close
	end
end
