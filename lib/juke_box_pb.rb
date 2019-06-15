# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: juke_box.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("juke_box.proto", :syntax => :proto3) do
    add_message "jukebox.TitleRequest" do
    end
    add_message "jukebox.SongRequest" do
      optional :title, :string, 1
    end
    add_message "jukebox.TitleResponse" do
      optional :title, :string, 1
    end
    add_message "jukebox.LylicResponse" do
      optional :lylic, :string, 1
    end
  end
end

module Jukebox
  TitleRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("jukebox.TitleRequest").msgclass
  SongRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("jukebox.SongRequest").msgclass
  TitleResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("jukebox.TitleResponse").msgclass
  LylicResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("jukebox.LylicResponse").msgclass
end
