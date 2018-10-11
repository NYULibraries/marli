FROM nyulibraries/selenium_chrome_headless_ruby:2.3.7-slim-chrome_69

ENV DOCKER true
ENV INSTALL_PATH /app
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV USER docker

RUN groupadd -g 2000 $USER -r && \
  useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g $USER $USER

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

RUN wget --no-check-certificate -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh \
  && chown docker:docker /tmp/wait-for-it.sh && chmod a+x /tmp/wait-for-it.sh

COPY bin/ bin/
COPY Gemfile Gemfile.lock ./
ARG RUN_PACKAGES="nodejs ruby-mysql2 default-libmysqlclient-dev git"
ARG BUILD_PACKAGES="build-essential zlib1g-dev"
RUN apt-get update && apt-get -y --no-install-recommends install $BUILD_PACKAGES $RUN_PACKAGES \
  && gem install bundler -v '1.16.5' \
  && bundle config --local github.https true \
  && bundle install --without no_docker --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf $BUNDLE_PATH/cache \
  && apt-get --purge -y autoremove $BUILD_PACKAGES \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && chown -R docker:docker $BUNDLE_PATH

USER $USER

COPY --chown=docker:docker . .
RUN bundle exec rake assets:precompile

CMD bundle exec rake
