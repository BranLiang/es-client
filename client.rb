require 'elasticsearch'
require 'aws-sdk-core'
require 'dotenv/load'

class Client
  attr_accessor :clicks
  def initialize
    @clicks = Elasticsearch::Client.new url: ENV['ES_CLICKS_URL'] do |f|
      f.request :aws_signers_v4,
                credentials: Aws::Credentials.new(ENV['ES_CLICKS_AWS_ACCESS_KEY'], ENV['ES_CLICKS_AWS_SECRET_ACCESS_KEY']),
                service_name: 'es',
                region: 'us-east-1'
    end
  end
end
