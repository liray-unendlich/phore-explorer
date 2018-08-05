![Bulwark Logo](https://bulwarkcrypto.com/wp-content/uploads/2018/04/blockexplorer.svg)

Bulwark Explorer
&middot;
[![GitHub license](https://img.shields.io/github/license/bulwark-crypto/bulwark-explorer.svg)](https://github.com/bulwark-crypto/bulwark-explorer/blob/master/COPYING) [![Build Status](https://travis-ci.org/bulwark-crypto/bulwark-explorer.svg?branch=master)](https://travis-ci.org/bulwark-crypto/bulwark-explorer) [![Discord](https://img.shields.io/discord/374271866308919296.svg)](https://discord.me/bulwarkcrypto) [![GitHub version](https://badge.fury.io/gh/bulwark-crypto%2Fbulwark-explorer.svg)](https://badge.fury.io/gh/bulwark-crypto%2Fbulwark-explorer)
=====

Block Explorer(マスターノード/Zerocoin対応)

## 必要条件
`git`, `mongodb`, `node`, `yarn`が導入されていることが前提です。各種設定は個々の環境に合わせてください。

ダウンロードリンク:

https://docs.mongodb.com/manual/administration/install-on-linux/

https://nodejs.org/en/download/package-manager/

https://yarnpkg.com/lang/en/docs/install/

また、各通貨のデーモン(ex. phored)が動作することも前提です。ブロックエクスプローラの設定をする前に同期を完了させていることをお勧めします。

デーモンのインストールスクリプト(Phore)

`bash script/phored_setup.sh`

このコマンドによりRPCユーザー名/パスワードを設定しPhoreデーモンを起動できます。

## インストール
`git clone https://github.com/liray-unendlich/phore-explorer.git` - レポをダウンロード

`cd phore-explorer` - レポ内へ移動

`yarn install` - 各種パッケージをダウンロード

## 設定
#### APIの設定
`cp config.template.js config.js` - テンプレートを利用し設定ファイルを作成

#### データベースの設定
`mongo` - mongodbの設定開始

`use blockex` - blockexという名称のデータベースを作成

`db.createUser( { user: "blockexuser", pwd: "Explorer!1", roles: [ "readWrite" ] } )` - ユーザー名/パスワードを指定しユーザーを作成。このユーザー名/パスワードはconfig.jsと一致させてください。

`exit` - mongodbの設定を終了

#### Cronタブの設定
block explorerの自動更新を行うための設定です。これをcrontabに書き込む前にここの環境に合わせpathを変更してください。cronを設定する前に`node cron/block.js`を実行するか、`/path/to/phore-explorer/script/cron_block.sh`を実行しブロックデータを一度取得してください。node.jsのパスに合わせ`/path/to/node`を変更してください。

`yarn run cron:coin` - coinの価格情報/流通情報をCoinMarketcap.comより取得します。

`yarn run cron:masternode` - マスターノードのリストを更新し、データベースへ保存します。

`yarn run cron:peer` - ピア情報の更新、保存を行います。

`yarn run cron:block` - ブロックデータの同期、保存を行います。

`yarn run cron:rich` - リッチリストの作成を行います。

`yarn run cron:proposal` - プロポーザルリストの作成を行います(データベースへの取得まで導入済み)。

__Note:__ crontabに追加する前に、各1回ずつ実行しておくことをお勧めします。

crontabの設定は `crontab -e`で行えます。各種パスはここの環境に合わせ設定してください。:
```
*/1 * * * * cd /path/to/blockex && ./script/cron_block.sh >> ./tmp/block.log 2>&1
*/1 * * * * cd /path/to/blockex && /path/to/node ./cron/masternode.js >> ./tmp/masternode.log 2>&1
*/1 * * * * cd /path/to/blockex && /path/to/node ./cron/peer.js >> ./tmp/peer.log 2>&1
*/1 * * * * cd /path/to/blockex && /path/to/node ./cron/rich.js >> ./tmp/rich.log 2>&1
*/5 * * * * cd /path/to/blockex && /path/to/node ./cron/coin.js >> ./tmp/coin.log 2>&1
```

## ビルド
クライアントのウェブインターフェースはwebpackを利用してビルドします。以下のコマンドを用いてビルドが可能で、
`yarn run build:web`
バンドル後 `/public` へデータを移しています。

## 実行
`yarn run start:api` - APIのスタート

`yarn run start:web` - ウェブをスタートし [http://localhost:8081](http://localhost:8081) で接続できます。

## テスト
`yarn run test:web` - クライアントサイドのテストを行います。

`yarn run test:server` - RPC, データベース, APIのテストを行います。

`yarn run test:rpc` - RPCのみのテストを行います。
