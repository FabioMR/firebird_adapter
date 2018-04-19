FROM ruby:2.5.1

WORKDIR /app

RUN apt-get update -qq && apt-get install -y libpq-dev build-essential locales firebird-dev

ENV LANG C.UTF-8

COPY . /app
RUN bundle
