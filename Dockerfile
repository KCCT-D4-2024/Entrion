FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client

# Install yarn
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
  && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn dos2unix

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /app


RUN yarn install --check-files && yarn list esbuild && yarn list tailwindcss

RUN gem install foreman

COPY ./entrypoint.sh /app
COPY ./bin/dev /app/bin/dev
RUN chmod +x /app/entrypoint.sh
RUN chmod +x /app/bin/dev
RUN dos2unix /app/entrypoint.sh /app/bin/dev

# binディレクトリのすべてのファイルに対してdos2unixを適用
RUN find /app/bin -type f -exec dos2unix {} \; && chmod +x /app/bin/*


# ビルド時の引数を定義
ARG USERNAME
# 環境変数を設定
ENV USERNAME ${USERNAME}

# 環境変数を使用
RUN if [ "$USERNAME" != "root" ]; then useradd $USERNAME --create-home --shell /bin/bash; fi && \
    chown -R $USERNAME:$USERNAME db log storage tmp

# assets/buildsディレクトリに対して書き込み権限を追加
RUN mkdir -p /app/app/assets/builds && chown -R $USERNAME:$USERNAME /app/app/assets/builds


ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
USER $USERNAME

EXPOSE 3000

CMD ["./bin/dev"]
