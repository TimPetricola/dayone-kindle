ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'

require 'minitest/reporters'
Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new(color: true))

require './lib/dayone-kindle'
