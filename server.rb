this_dir = File.expand_path(File.dirname(__FILE__))

lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

data_dir = File.join(this_dir, 'datas')
$LOAD_PATH.unshift(data_dir) unless $LOAD_PATH.include?(data_dir)

require 'grpc'
require 'juke_box_services_pb'
require 'song_list'

class LylicEnumerator
  def initialize(lylics)
    @lylics = lylics
  end

  def each
    return enum_for(:each) unless block_given?

    @lylics.each do |lylic|
      # Assuming some downloading or processing.
      sleep 1
      puts lylic
      yield Jukebox::LylicResponse.new(lylic: lylic)
    end
  end
end

class JukeBoxServiceImpl < Jukebox::JukeBox::Service
  def choose(_request, _call)
    chosen_song = SongList::LIST.sample
    Jukebox::TitleResponse.new(title: chosen_song[:title])
  end

  def play(request, _call)
    title = request.title
    requested_song = SongList::LIST.find { |song| song[:title] == title }

    LylicEnumerator.new(requested_song[:lylics]).each
  end
end

addr = '0.0.0.0:50051'

server = GRPC::RpcServer.new

server.add_http2_port(addr, :this_port_is_insecure)
p "... running insecurely on #{addr}"

server.handle(JukeBoxServiceImpl.new)
server.run_till_terminated
