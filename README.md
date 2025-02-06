# setting01
## 環境構築
### Gitをクローンしてプロジェクトを設定
#### 1.リポジトリをクローン
- まずは GitHub にある基本設計のリポジトリをローカル環境にクローンします。
``` bash
git clone git@github.com:mdrgreen39/setting01.git
```
#### 2.プロジェクト名を変更
``` bash
mv setting01 new-project-name
```

#### 3.リモートリポジトリを設定
- 新しいプロジェクト用に GitHub 上でリモートリポジトリを作成し、ローカルリポジトリにそのリモートリポジトリを紐づけます。
``` bash
git remote set-url origin git@github.com:your-username/new-repository.git

```
#### 4.必要に応じて初期設定を変更
- プロジェクトの基本設定（例: .gitignore や README.md など）を編集し、初期化を完了します。

### Nuxtインストール
nuxtディレクトリを作っておく必要はない。作らずにsrcルートでコマンドを実行すればディレクトリは作られる。
#### 1.src/nuxt ルートで Nuxt.js を初期設定 (Nuxt 3)
``` bash
npx nuxi init .
```
#### 2.
- パッケージ選択(npm(初心者ならデフォルトでOK) or pnpm(速度重視) or yarn(チームで使ってるなら))
- gitリポジトリ初期化選択
- Project name 入力
- TypeScript
- Tailwind Css
- HTML
- Axios
- EsLint Prettier
- Jest
- jsconfig.json
- GitHub Actions
- Git

#### 3.
``` bash
npm install
```
### 4から6についてはインストールするもによって実行するかしないか変わる。Nuxt3は必要なものを手動でインストールする
#### 4.nuxt.config.ts
``` bash
// https://nuxt.com/docs/api/configuration/nuxt-config
import { defineNuxtConfig } from 'nuxt/config'
import { types } from 'util'  // util モジュールから cloneDeep をインポート
import { cloneDeep } from 'lodash';

export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  hooks: {
    'build:before': () => {
      if (typeof structuredClone === 'undefined') {
        globalThis.structuredClone = cloneDeep;  // structuredClone が未定義なら cloneDeep を代わりに使う
      }
    }
  }
})
```
nuxt/config にする
#### 5.lodash パッケージをインストールし、そこから cloneDeep をインポートする
``` bash
npm install lodash

```
#### 6.@types/lodash をインストール
``` bash
npm install --save-dev @types/lodash

```
#### 7.package.json の scripts セクションを確認し、start スクリプトを定義する
``` bash
"start": "nuxt start",
```
追加？
``` bash
"optionalDependencies": {
    "@rollup/rollup-linux-x64-musl": "^4.34.2"
}
```

### Dockerビルド
#### 1. DockerDesktopアプリを立ち上げる
#### 2.
``` bash
docker compose up -d --build
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

### 参考。nuxtの依存関係でうまくいかない時
#### 1.コンテナ内で`npm install`する
``` bash
docker compose exec nuxt bash
```
``` bash
docker compose run --rm nuxt sh
```
#### 2.
``` bash
npm install
```
#### 3.ルートに戻ってコンテナ内を完全にリセット
``` bash
docker compose down
```
#### 4.
``` bash
docker compose up -d --build
```

### Laravel環境構築
#### 1.
``` bash
docker compose exec php bash
```
#### 2.
``` bash
composer create-project --prefer-dist laravel/laravel src/laravel "10.*"
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

#### 1.
``` bash
```# jwt
