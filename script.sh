#!/bin/bash

gem install bundler

bundle install

src/ruby main.rb $1 $2