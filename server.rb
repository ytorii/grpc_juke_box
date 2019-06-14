this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'juke_box_services_pb'

class JukeBoxImpl < Jukebox::JukeBox::Service
  def play_song(request, _call)
    p request
    song = Jukebox::Song.new(artist: 'aa', title: 'a Song')
    Jukebox::SongResponse.new(song: song)
  end
end

addr = '0.0.0.0:50051'

server = GRPC::RpcServer.new

server.add_http2_port(addr, :this_port_is_insecure)
p "... running insecurely on #{addr}"

server.handle(JukeBoxImpl.new)
server.run_till_terminated
