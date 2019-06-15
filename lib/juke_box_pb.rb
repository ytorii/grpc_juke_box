# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: juke_box.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("juke_box.proto", :syntax => :proto3) do
    add_message "jukebox.GenreRequest" do
      optional :genre, :enum, 1, "jukebox.Genre"
    end
    add_message "jukebox.TitleResponse" do
      optional :title, :string, 1
    end
    add_enum "jukebox.Genre" do
      value :POP, 0
      value :ROCK, 1
      value :ANIME, 2
    end
  end
end

module Jukebox
  GenreRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("jukebox.GenreRequest").msgclass
  TitleResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("jukebox.TitleResponse").msgclass
  Genre = Google::Protobuf::DescriptorPool.generated_pool.lookup("jukebox.Genre").enummodule
end
