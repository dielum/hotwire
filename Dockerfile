# Imagen principal
FROM ruby:3.1.1

# se instalan dependencias
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

# Directoro de trabajo
RUN mkdir /hotwire
WORKDIR /hotwire

# BUNDLE_PATH
ENV BUNDLE_PATH /bundle
ENV GEM_PATH /bundle
ENV GEM_HOME /bundle

# Instalar Gemas
RUN gem install bundler:2.3.10
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs "$(nproc)"

# Se instalan dependencias de Node
RUN npm install -g yarn
COPY package.json /hotwire
COPY yarn.lock /hotwire
RUN yarn install

# Se copia lo que resta del proyecto
ADD . /hotwire

# Se compilan assets
RUN bundle exec rails assets:clobber && bundle exec rails assets:precompile
RUN rm -f /hotwire/tmp/pids/server.pid

# Se ejecuta el servidor
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]