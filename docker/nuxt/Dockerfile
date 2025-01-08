# ベースイメージ
FROM node:18-alpine

# 作業ディレクトリを作成
WORKDIR /usr/src/app

# パッケージをコピーしてインストール
COPY package*.json ./

# 開発用依存パッケージをインストール
RUN npm install

# アプリケーションコードをコピー
COPY . .

# デフォルトコマンド (Nuxt 開発モード)
CMD ["npm", "run", "dev"]
