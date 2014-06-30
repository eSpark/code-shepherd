require 'rspec'
require 'faker'
require 'securerandom'
# we test the command line output against the Git library
require 'git'

require 'elodin'

RSpec.configure do |config|
    config.before do
      Elodin.logger.level = Logger::WARN
    end
end
