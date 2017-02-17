#!/usr/bin/ruby

  @servername = 'server.com'
  @username = 'username'
  @password = 'password'

def log(level, msg)
  puts "#{msg}"
end

def call_cloudforms(action, ref=nil, body=nil)
  require 'rest_client'
  require 'json'
  require 'base64'

  url = "https://#{@servername}/api"
  url += "#{ref}" if ref

  params = {
    :method=>action, :url=>url, :verify_ssl=>false,
    :headers=>{ :content_type=>:json, :accept=>:json, :authorization => "Basic #{Base64.strict_encode64("#{@username}:#{@password}")}" }
  }
  params[:payload] = body.to_json if body
  log(:info, "Calling url: #{url} action: #{action} payload: #{params}")

  response = RestClient::Request.new(params).execute
  log(:info, "response headers: #{response.headers}")
  log(:info, "response code: #{response.code}")
  log(:info, "response: #{response}")
  # response_hash = JSON.parse(response)
  return response
end

cf_result = call_cloudforms(:get, '/vms?by_tag=/lob/demo')
log(:info, "cf_result: #{cf_result.inspect}")
