require 'elasticsearch'
require 'aws-sdk-resources'
require 'dotenv/load'
require 'time'
require 'faraday_middleware/aws_signers_v4'

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

  def delete_es
    time = Time.parse('2018-12-31 23:58:00')
    # final = Time.parse('2019-01-02 00:00:01')
    final = Time.parse('2019-01-01 00:10:00')
    while time <= final do
      puts time.strftime("%Y-%m-%dT%H:%M:%S.%3N")
      clicks.delete_by_query(
        index: 'clicks',
        body: {
          conflicts: 'proceed',
          query: {
            range: {
              time: {
                lte: time.strftime("%Y-%m-%dT%H:%M:%S.%3N")
              }
            }
          }
        }
      )
      time = time + 10
    end
  end

end
