# Node.jsのイメージを指定
FROM node:18-alpine

# 作業ディレクトリを設定
WORKDIR /usr/src/app

# 必要なファイルをコピー（ローカルの ./src/nuxt をコンテナの /usr/src/app にコピー）
COPY ./src/nuxt/ ./


# package.json と package-lock.json をコピー
COPY ./src/nuxt/package*.json ./

# npm installを実行
RUN npm install

# node_modules/.bin を PATH に追加
ENV PATH="/usr/src/app/node_modules/.bin:$PATH"


# アプリをビルド
RUN npx nuxi build

# サーバーを起動
CMD ["npx", "nuxt", "start"]
