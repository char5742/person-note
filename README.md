# アプリの説明

これは私が使いたいと思うメモアプリです。私は人のことを覚えるのが苦手なため、いつでも見返せるものがほしかったのです。もともとは名前と誕生日、ちょっとした補足を保存できればいいかなくらいの考えでしたが、作っていくうちに興が乗ったため、いつ誰と何をしたのかという「イベント」も保存できるようにしました。  
データの保存にはFireStoreとAuthenticationを利用しています。そのためGoogleのアカウントがあればどの端末からでもアクセスできるようになっています。（もともとはRealtimeDBを使用していましたが、イベント機能追加にあたりクエリの強いFireStoreに変更しました。）

# 設計方針

MVVM + UseCase   
Page <-> Provider <-> UseCase 

サンプルアーキテクチャを参考にしましたが、FireStore自体にキャッシュ機能などがあるため、Repositoryはなく、UseCaseで完結しています。

# 工夫したところ

githubの管理から、アプリの機能、バグのなさ、コードの可読性、アーキテクチャまで全てに全力であたりました。  
それはそれとして、今回初めて挑戦した要素は以下になります。できるかぎりいろいろと挑戦してみました。
- Firestore + Authentication  
- UsecaseImpl
- integration_test
- README記載
- Localization
- GithubActions

### 画面について
ページのデザインはTwitterを参考にしました。DetailPageの構成もそうですし、縦の三点リーダーによる編集、削除や、削除選択時の確認ダイアログなどもです。

# 動作環境
```
Flutter 3.7.0-1.5.pre • channel beta • https://github.com/flutter/flutter.git
Framework • revision 099b3f4bf1 (6 days ago) • 2023-01-20 18:35:12 -0800
Engine • revision 45c5586f2a
Tools • Dart 2.19.0 (build 2.19.0-444.6.beta) • DevTools 2.20.1
```

動作確認は Xperia1Ⅱ Android11のみで行いました。

# 感想
これでgithubに公開しているFlutterアプリが２つになりました。夏休みに、就活に使うためにチャットアプリを作りましたがそこからまた更に成長できたかなと思います。