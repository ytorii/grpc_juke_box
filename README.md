# grpc_juke_box
RubyではじめるgRPCハンズオンで使用するコードのリポジトリです。

## ハンズオン手順

### .protoファイルの作成
- `protos`ディレクトリを作る

- `protos/juke_box.proto` を作成

```
syntax = "proto3";

package jukebox;

service JukeBox {
  rpc Choose(TitleRequest) returns (TitleResponse) {}
}

message TitleRequest {}

message TitleResponse {
  string title = 1;
}
```

### インターフェース部分のコードの生成
- `grpc` `grpc-tools` gem のインストール
`bundle install`

- `lib`ディレクトリを作成

- `protoc` コマンドでソースコードを生成
`bundle exec grpc_tools_ruby_protoc -I ./protos--ruby_out=./lib --grpc_out=./lib ./proto/juke_box.proto`

- `lib`に2種類のファイルが生成されているのを確認
  - `juke_box_pb.rb`
  - `juke_box_services_pb.rb`
  
### サーバの作成

- `server.rb`を開く

- 必要ライブラリの読み込み
```
require 'grpc'
require 'juke_box_services_pb'
require 'song_list'
```

- JukeBoxの実装
```
class JukeBoxServiceImpl < Jukebox::JukeBox::Service
  def choose(_request, _call)
    chosen_song = SongList::LIST.sample
    Jukebox::TitleResponse.new(title: chosen_song[:title])
  end
end
```

- ホストの設定

`addr = '0.0.0.0:50051'`

- サーバの設定と起動
```
server = GRPC::RpcServer.new

server.add_http2_port(addr, :this_port_is_insecure)
p "... running insecurely on #{addr}"
```

- ハンドラの登録と終了時の設定
```
server.handle(JukeBoxServiceImpl.new)
server.run_till_terminated
```
