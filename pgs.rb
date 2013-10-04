require 'rubygems'
require 'grooveshark'

client = Grooveshark::Client.new
session = client.session

search_string = ""
ARGV.each do |a|
  search_string = search_string + "#{a} "
end
search_string.strip!

songs = client.search_songs(search_string)
song = songs.first
url = client.get_song_url(song)

read_io, write_io = IO.pipe

child = fork do
  write_io.close
  STDIN.reopen(read_io)
  `mplayer -really-quiet "#{url}"`
end

read_io.close
sleep 10
write_io.write " "
sleep 5
write_io.write " "
write_io.close

Process.wait child

