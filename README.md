# setting01
## 環境構築
### Dockerビルド
#### 1.
``` bash
git clone git@github.com:mdrgreen39/setting01.git
```
#### 2. DockerDesktopアプリを立ち上げる
#### 3.
``` bash
docker　compose up -d --build
```

> *MacのM1・M2チップのPCの場合、`no matching manifest for linux/arm64/v8 in the manifest list entries`のメッセージが表示されビルドができないことがあります。
エラーが発生する場合は、docker-compose.ymlファイルの「mysql」内に「platform」の項目を追加で記載してください*
``` bash
mysql:
    platform: linux/x86_64(この文を追加)
    image: mysql:8.0.37
    environment:
```
``` bash
platform: linux/x86_64
```
> *Dockerコンテナをビルドした後に、vendor ディレクトリが生成されていないため、composer install を実行して依存関係をインストールする必要があります。queue-workerコンテナの`STATUS`が`Restarting`でもそのまま次の手順`composer install`を実行し、実行後に再度dockerコンテナの状態を確認してください。*

### Laravel環境構築
#### 1.
``` bash
docker compose exec php bash
```
#### 2.
``` bash
composer install
```
#### 3. `.env.example`ファイルを `.env`ファイルに命名を変更。または、新しく`.env`ファイルを作成
- `.env`に以下の環境変数を追加
``` text
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=laravel_pass
QUEUE_CONNECTION=database
LIVEWIRE_DEBUG=true           //追加
STORAGE_URL=http://localhost  //追加
```

#### 4. アプリケーションキーの作成
``` bash
php artisan key:generate
```

#### 5. キューワーカーの再起動
``` bash
php artisan queue:restart
```

## 設定例
#### メール設定
メール送信に **Mailtrap** を使用します。以下の手順に従って設定してください。
  - Mailtrapの設定手順
     1. [Mailtrap公式サイト](https://mailtrap.io/)にアクセスし、アカウントを作成します。
     2. SMTP設定情報を取得します。
      - SMTP Settings タブををクリック
      - Integrations セレクトボックスで、Laravel 9+ を選択
      - copy ボタンをクリックして、クリップボードに .env の情報を保存
     3. mailtrap からコピーした情報を、プロジェクトの `.env` ファイルに貼り付ます。

```text
MAIL_DRIVER=smtp
MAIL_HOST=sandbox.smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=    //送信元のメールアドレス
MAIL_FROM_NAME="${APP_NAME}"   //メールの送信者に表示される名前
```

#### Stripe設定
決済機能としてStripeを使用します。以下の手順に従って設定してください。
  - Stripeの設定手順
    1. [Stripe公式サイト](https://stripe.com/jp)にアクセスし、アカウントを作成します。
    2. アカウントが作成できたら、ダッシュボードにログインします。
    3. 「開発者」セクションに移動し、テスト用のAPIキーを取得します。テスト用の公開可能キーとシークレットキーが表示されます。
    4. 環境変数（`.env`ファイル）に以下のようにAPIキーを設定します。
``` text
STRIPE_KEY=テスト用公開可能キー
STRIPE_SECRET=テスト用シークレットキー
```
 - Stripe公式テストカード一覧ページ : [Stripe Testing Cards](https://docs.stripe.com/testing)

#### ストレージ設定
``` bash
php artisan storage:link
```
> *注意事項:
ローカル環境でのテスト時には、ファイルストレージのパーミッションに注意してください。適切に設定されていないと、QRコードの保存や読み込みが正常に行われないことがあります。*

**解決策**
  1. パーミッションの設定: 次のコマンドを実行して、`storage `ディレクトリのパーミッションを適切に設定してください。
``` bash
chmod -R 775 storage
```
  2. 所有者の確認: ストレージディレクトリの所有者がウェブサーバーのユーザー（通常は `www-data` や `nginx` など）になっているかを確認します。<br>
    確認するコマンド例：
``` bash
ls -la storage
```
> 出力例:`drwxrwxr-x  2 user group 4096 Oct 11 12:00 app`
   3. 問題が解決されない場合: 必要に応じて、サーバーの設定を見直し、適切なパーミッションが設定されているか再確認してください。
