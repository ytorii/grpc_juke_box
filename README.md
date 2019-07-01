# grpc_juke_box
RubyではじめるgRPCハンズオンで使用するコードのリポジトリです。

## 曲のランダム選択

### .protoファイルの作成
- `protos`ディレクトリを作る

- `protos/juke_box.proto` を作成

```
syntax = "proto3";

package kyotorb;

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

  - `bundle install`

- `lib`ディレクトリを作成

- `protoc` コマンドでソースコードを生成

`bundle exec grpc_tools_ruby_protoc -I ./protos --ruby_out=./lib --grpc_out=./lib ./protos/juke_box.proto`

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
class JukeBoxServiceImpl < Kyotorb::JukeBox::Service
  def choose(_request, _call)
    chosen_song = SongList::LIST.sample
    Kyotorb::TitleResponse.new(title: chosen_song[:title])
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
server.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
```

### サーバの起動
- `ruby server.rb`
  - 以下のように表示されればOK
  
```
ytorii@ytorii-PS42-8RB:~/ruby/grpc_enum$ ruby server.rb 
"... running insecurely on 0.0.0.0:50051"
```

### クライアントの作成

- `client.rb`を開く

- 必要ライブラリの読み込み
  - サーバと同じインターフェースを読み込んでいることに注目
  
```
require 'grpc'
require 'juke_box_services_pb'
```

- 接続先サーバの指定

`HOST = 'localhost:50051'.freeze`

- RPCメソッド
  - ローカルのstubインスタンスのchooseメソッドの実行で、外部サーバのメソッドを呼び出せていることに注目
```
def choose_song
  stub = Kyotorb::JukeBox::Stub.new(HOST, :this_channel_is_insecure)
  request = Kyotorb::TitleRequest.new

  response = stub.choose(request)
  response.title
end
```

- 実行メソッド
```
def main
  title = choose_song
  p title
end

main
```

### クライアントの実行
- `ruby client.rb`
  - 以下のように何らかの曲名が表示されればOK
  
```
ytorii@ytorii-PS42-8RB:~/ruby/grpc_enum$ ruby client.rb 
"The ants go marching"
```

## 曲の再生

### .protoファイルへの追加

- rpc の追加

`rpc Play(SongRequest) returns (stream LylicResponse) {}`

- リクエスト用 Message の追加
```
message SongRequest {
  string title = 1;
}
```

- レスポンス用 Message の追加
```
message LylicResponse {
  string lylic = 1;
}
```

### インターフェース部分のコードの再作成

- `protoc` コマンドでソースコードを再生成

`bundle exec grpc_tools_ruby_protoc -I ./protos--ruby_out=./lib --grpc_out=./lib ./proto/juke_box.proto`
  
### サーバ側の実装

- `server.rb`を開く

- playメソッドの実装

```
  def play(request, _call)
    title = request.title
    requested_song = SongList::LIST.find { |song| song[:title] == title }

    LylicEnumerator.new(requested_song[:lylics]).each
  end
```

- Streamで渡すEnumeratorの実装
```
class LylicEnumerator
  def initialize(lylics)
    @lylics = lylics
  end

  def each
    return enum_for(:each) unless block_given?

    @lylics.each do |lylic|
      # Assuming some downloading or processing.
      sleep 1
      yield Kyotorb::LylicResponse.new(lylic: lylic)
    end
  end
end
```

### サーバの起動
- `ruby server.rb`
  - 以下のように表示されればOK
  
```
ytorii@ytorii-PS42-8RB:~/ruby/grpc_enum$ ruby server.rb 
"... running insecurely on 0.0.0.0:50051"
```

### クライアント側の実装

- `client.rb`を開く

- play_songメソッドの実装
```
def play_song(title)
  request = Kyotorb::SongRequest.new(title: title)
  stub = Kyotorb::JukeBox::Stub.new(HOST, :this_channel_is_insecure)

  responses = stub.play(request)

  puts "Now playing: #{title}"

  responses.each do |res|
    puts res.lylic
  end

  puts 'Thank you for listening!'
end
```

- 実行メソッドの変更
```
def main
  title = choose_song
  play_song(title)
end

main
```

### クライアントの実行
- `ruby client.rb`
  - 以下のように何らかの曲名と歌詞が表示されればOK
  
```
ytorii@ytorii-PS42-8RB:~/ruby/grpc_enum$ ruby client.rb 
Now playing: Baa, Baa, Black Sheep
Baa, baa, black sheep, Have you any wool?
Yes, sir, yes, sir,
Three bags full
Thank you for listening!
```
