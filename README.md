# Qiita Profiler

「[Qiitaでストックされた記事の傾向と対策](http://qiita.com/cognitom/items/8f702e33903f9f890451)」を書くのに使ったスクリプトです。指定ユーザの記事リストに、各記事のストック数を付けたCSVファイルを生成します。

## 使い方

`gulpfile.coffee`内の、`QIITA_USER`と`QIITA_AUTH`は各自のものを設定し、下記のコマンドを実行します。`profile.csv`に記事一覧を吐き出してくれるはずです。

```bash
$ npm install
$ gulp
```

## アクセストークンの取得

Qiita APIを利用するための、アクセストークンの取得についてはこちらに説明があります。

- [Qiita API v2 ドキュメント - アクセストークン](https://qiita.com/api/v2/docs#%E8%AA%8D%E8%A8%BC%E8%AA%8D%E5%8F%AF)
