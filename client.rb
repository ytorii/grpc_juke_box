this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'juke_box_services_pb'

def main
  stub = Jukebox::JukeBox::Stub.new('localhost:50051', :this_channel_is_insecure)
  request = Jukebox::SongRequest.new
  pp request
  begin
    selected_song = stub.play_song(request)
    pp selected_song
  rescue => e
    pp e
  end
end

main
