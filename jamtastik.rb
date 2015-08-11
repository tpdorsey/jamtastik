require 'json'
require 'jsonpath'
require "net/http"
require "uri"

# Read and hash JSON from API call
def callApi(uri)
  response = Net::HTTP.get_response(URI.parse(uri))
  if response.code == "200"
    return JSON.parse(response.body)
  else
    puts "Error: API response " + response.code + " " + response.status
  end
end

# Read and hash JSON
json_hash = callApi(ARGV[0])

json_hash["jams"].each do |jam|

  puts '"' + jam["title"] + '", by ' + jam["artist"]

end