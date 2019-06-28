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

