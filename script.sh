#!/bin/bash

gem install bundler

bundle install

ruby src/main.rb $1 $2