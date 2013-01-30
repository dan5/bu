# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

namespace :events do
  desc 'closing events'
  task :close do
    Event.be_ended_all
  end
end
