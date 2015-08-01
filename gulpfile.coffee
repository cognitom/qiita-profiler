gulp    = require 'gulp'
request = require 'request-promise'
fs      = require 'fs'

QIITA_BASE = 'http://qiita.com/api/v2'
QIITA_USER = '' # ユーザ名を設定
QIITA_AUTH = '' # アクセストークンを設定
PER_PAGE   = 100 # 最大100

# デフォルト設定
request = request.defaults
  resolveWithFullResponse: true
  headers: Authorization: "Bearer #{ QIITA_AUTH }"

gulp.task 'default', (callback) ->
  posts = []
  request
    uri: "#{ QIITA_BASE }/users/#{ QIITA_USER }/items?per_page=#{ PER_PAGE }"
  .then (response) ->
    # ユーザの投稿一覧
    posts =
      for row in (JSON.parse response.body)
        id:         row.id
        title:      row.title
        created_at: row.created_at.replace /T.+$/, ''
    # 投稿ごとのストック数を取得
    # ただし、1投稿ごとしか取得できないため、thenで繋いで順番に実行
    promise = Promise.resolve()
    for i in [0...posts.length]
      do (i) -> promise = promise.then -> doItLater (cb) ->
        request
          uri: "#{ QIITA_BASE }/items/#{ posts[i].id }/stockers"
        .then (res) ->
          posts[i].count = res.headers['total-count']
          cb()
    promise
  .then ->
    # CSVファイルに保存
    stream = fs.createWriteStream 'profile.csv'
    stream.write "id,title,created_at,count\n"
    for post in posts
      stream.write "#{ post.id },\"#{ post.title }\",#{ post.created_at },#{ post.count || 0 }\n"
    stream.end()
    callback()
  return

# 少し待って実行するための関数
doItLater = (callback) ->
  new Promise (resolve, reject) ->
    setTimeout ->
      callback -> resolve()
    , 500
