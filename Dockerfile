FROM ruby:3.1.1

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  curl \
  build-essential \
  libpq-dev \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /hotwire
WORKDIR /hotwire

ARG BUNDLE_PATH
ENV BUNDLE_PATH $BUNDLE_PATH
ENV GEM_PATH $BUNDLE_PATH
ENV GEM_HOME $BUNDLE_PATH

RUN gem install bundler:2.3.10
RUN gem install foreman
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs "$(nproc)"

RUN npm install -g yarn
COPY package.json /hotwire
COPY yarn.lock /hotwire
RUN yarn install

ADD . /hotwire

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]