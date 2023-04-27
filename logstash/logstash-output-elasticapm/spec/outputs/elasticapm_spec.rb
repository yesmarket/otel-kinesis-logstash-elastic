# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/elasticapm"
require "logstash/codecs/plain"
require "logstash/event"

describe LogStash::Outputs::Elasticapm do
  let(:apm_server_uri) { 'test' }
  let(:api_key) { 'test' }

  let(:cfg) {
    { 
      "apm_server_uri" => apm_server_uri, 
      "api_key" => api_key
    }
  }

  let(:output) { LogStash::Outputs::Elasticapm.new(cfg) }

  before do
    output.register
  end

  describe "receive" do
    it "test" do
      log = {
        :requestId => "789c0eed-aaae-4e52-a5c0-8ff4dfe8678f",
        :timestamp => 1682605997,        
        :records => [
          {
            :data => "CuAGCnkKHAoMc2VydmljZS5uYW1lEgwKCmRvdG5ldC1hcGkKGgoPc2VydmljZS52ZXJzaW9uEgcKBTEuMC4wCj0KE3NlcnZpY2UuaW5zdGFuY2UuaWQSJgokODJiZTgyMTUtNjFmYi00YTQzLWExMmQtODc1NTA1YmUyM2NlEuQBCjwKMU9wZW5UZWxlbWV0cnkuSW5zdHJ1bWVudGF0aW9uLkVudGl0eUZyYW1ld29ya0NvcmUSBzEuMC4wLjYSowEKELkGuBbSjnhnw8k0ZdT3yRcSCJUrmpVg+qsJIgieEDk0IFmkmioEbWFpbjADOXzGYKE80VkXQfwew6I80VkXShUKCWRiLnN5c3RlbRIICgZzcWxpdGVKEQoHZGIubmFtZRIGCgRtYWluShgKDHBlZXIuc2VydmljZRIICgZ1bmkuZGJKGwoRZGIuc3RhdGVtZW50X3R5cGUSBgoEVGV4dHoAEvsDCjMKKE9wZW5UZWxlbWV0cnkuSW5zdHJ1bWVudGF0aW9uLkFzcE5ldENvcmUSBzEuMC4wLjASwwMKELkGuBbSjnhnw8k0ZdT3yRcSCJ4QOTQgWaSaIgAqCFN0dWRlbnRzMAI5IEtqUTzRWRdB6FL/pTzRWRdKIQoNbmV0Lmhvc3QubmFtZRIQCg4xOTIuMTY4Ljk5LjEwNkoUCg1uZXQuaG9zdC5wb3J0EgMYiidKFAoLaHR0cC5tZXRob2QSBQoDR0VUShUKC2h0dHAuc2NoZW1lEgYKBGh0dHBKGgoLaHR0cC50YXJnZXQSCwoJL1N0dWRlbnRzSjEKCGh0dHAudXJsEiUKI2h0dHA6Ly8xOTIuMTY4Ljk5LjEwNjo1MDAyL1N0dWRlbnRzShQKC2h0dHAuZmxhdm9yEgUKAzEuMUqEAQoPaHR0cC51c2VyX2FnZW50EnEKb01vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS8xMTIuMC4wLjAgU2FmYXJpLzUzNy4zNkoYCgpodHRwLnJvdXRlEgoKCFN0dWRlbnRzShcKEGh0dHAuc3RhdHVzX2NvZGUSAxjIAXoA"
          }
        ]
      }
      event = LogStash::Event.new(log) 
      expect {output.receive(event)}.to_not raise_error
    end
  end
end
