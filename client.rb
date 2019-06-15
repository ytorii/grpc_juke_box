this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'juke_box_services_pb'

def main
  stub = Jukebox::JukeBox::Stub.new('localhost:50051', :this_channel_is_insecure)
  genre = ARGV.size > 0 ?  ARGV[0] : :POP

  request = Jukebox::GenreRequest.new(genre: genre)
  response = stub.choose_song(request)
  title = response.title

  puts "Your song is: #{title}"
end

main
