FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client

# Install yarn
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
  && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /app

RUN yarn install --check-files

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# ビルド時の引数を定義
ARG USERNAME
# 環境変数を設定
ENV USERNAME ${USERNAME}

# 環境変数を使用
RUN if [ "$USERNAME" != "root" ]; then useradd $USERNAME --create-home --shell /bin/bash; fi && \
    chown -R $USERNAME:$USERNAME db log storage tmp
USER $USERNAME

EXPOSE 3000

CMD ["./bin/dev"]
