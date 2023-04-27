# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "rest-client"
require "json"
require "jsonpath"
require "base64"

# An elasticapm output that does nothing.
class LogStash::Outputs::Elasticapm < LogStash::Outputs::Base
  config_name "elasticapm"

  public
  def register    
  end # def register

  public
  def receive(event)
    puts "test"
  end # def event
end # class LogStash::Outputs::Elasticapm
