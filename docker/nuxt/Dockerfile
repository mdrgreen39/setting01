# Node.jsのイメージを指定
FROM node:18-alpine

# 作業ディレクトリを設定
WORKDIR /usr/src/app

# 必要なファイルをコピー（ローカルの ./src/nuxt をコンテナの /usr/src/app にコピー）
COPY ./src/nuxt /usr/src/app/src/nuxt


# /src/nuxt 内に移動
WORKDIR /usr/src/app/src/nuxt

# npm installを実行
RUN npm install

# アプリをビルド
RUN npm run build

# サーバーを起動
CMD ["npm", "run", "start"]
