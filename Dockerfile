FROM ruby:3.2
WORKDIR /app
COPY Gemfile Gemfile.lock /app
RUN bundle install
EXPOSE 4567
