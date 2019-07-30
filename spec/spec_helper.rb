require 'rspec'
require 'pg'
require 'album'
require 'artist'
require 'song'
require 'pry'

DB = PG.connect({:dbname => 'record_store'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;")
    DB.exec("DELETE FROM songs *;")
  end
end
