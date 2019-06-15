this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'juke_box_services_pb'

HOST = 'localhost:50051'.freeze

def choose
  stub = Jukebox::JukeBox::Stub.new(HOST, :this_channel_is_insecure)
  request = Jukebox::TitleRequest.new

  response = stub.choose(request)
  response.title
end

def play(title)
  request = Jukebox::SongRequest.new(title: title)
  stub = Jukebox::JukeBox::Stub.new(HOST, :this_channel_is_insecure)

  responses = stub.play(request)

  puts "Now playing: #{title}"

  responses.each do |res|
    puts res.lylic
  end

  puts 'Thank you for listening!'
end

def main
  title = choose
  play(title)
end

main
