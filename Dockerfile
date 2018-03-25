FROM ruby:2.5


RUN gem install bundler

COPY Gemfile /recs-gen/
COPY Gemfile.lock /recs-gen/

WORKDIR /recs-gen
RUN bundle install

COPY bin bin
COPY lib lib
COPY templates/haproxy.cfg.erb .

EXPOSE 7419 7420
CMD ["/recs-gen/bin/recs-gen", "--region", "us-east-1", "--cluster", "iron-age", "--template", "/recs-gen/haproxy.cfg.erb", "--output", "/haproxy.cfg", "--loglevel", "debug"]
