# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

namespace :events do
  desc 'close the events of past'
  task :close do
    Event.be_ended_all
  end
end
