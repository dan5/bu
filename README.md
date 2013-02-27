[![Build Status](https://travis-ci.org/1syo/bu.png?branch=master)](https://travis-ci.org/1syo/bu)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/1syo/bu)
[![Dependency Status](https://gemnasium.com/1syo/bu.png)](https://gemnasium.com/1syo/bu)

# Bu

あたりまえの部活管理ツール。


# 動かし方

```
$ bundle install --path vendor/bundle
$ rake db:setup
$ rails server
```

# 情報

- [Preview Site](http://bukt-preview.herokuapp.com)
- [Latest Coverage](http://bukt-coverage.herokuapp.com/#_AllFiles)
- [Rails Best Practices](http://railsbp.com/repositories/304-1syo-bu)
- [Build Status](https://travis-ci.org/1syo/bu)
- [Code Climate](https://codeclimate.com/github/1syo/bu)
- [Dependency Status](https://gemnasium.com/1syo/bu)

# 開発に参加するには

- [buktdev - Lingr](http://lingr.com/room/buktdev) に開発の相談ができるチャットルームを設置しています。
- `rake routes` でルートの一覧を表示できます。
- `rake spec` を実行し、既存のテストを壊していないことを確認してください。
- git に不慣れな方は以下を参考にしてください。わからないところは気軽に Lingr で聞いてください。
  - [GitHubへpull requestする際のベストプラクティス](http://d.hatena.ne.jp/hnw/20110528)  
  「6. commitを1つにまとめます（あとで説明します）」は必須ではありません。それぞれのコミットが一つの固まりとして適切であるようにしてください。（たとえば何らかの理由で変更を破棄したいとき、revert しやすい単位になっていますか？）
  - [Git-での分散作業-プロジェクトへの貢献#小規模な公開プロジェクト](http://git-scm.com/book/ja/Git-での分散作業-プロジェクトへの貢献#小規模な公開プロジェクト)
- Pull Request は 1syo/bu の master ブランチに向けて送ってください。
- **[http://bukt.org/](http://bukt.org/) で稼働中のサービスとはソースが異なっています。**
