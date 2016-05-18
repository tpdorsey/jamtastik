require 'json'
require 'jsonpath'
require "net/http"
require "uri"

$jams = Array.new

# Read and hash JSON from API call
def callApi(uri)
  response = Net::HTTP.get_response(URI.parse(uri))
  if response.code == "200"
    return JSON.parse(response.body)
  else
    puts "Error: API response " + response.code + " " + response.status
  end
end

def getJams(uri)
  # Read and hash JSON
  json_hash = callApi(uri)

  json_hash["jams"].each do |jam|

    $jams << jam

  end

  if json_hash["list"]["hasMore"]
    getJams(json_hash["list"]["next"])
  end
end

jammer = ARGV[0]
api_uri = "http://api.thisismyjam.com/1/" + jammer + "/jams.json"

# puts "<!doctype html><html><head>"
# puts "</head><body>"
# puts "<h1>Jams by " + jammer + "</h1>"

getJams(api_uri)

# $jams.reverse!

$jams.each do |jam|

  # puts jam

  puts ""
  puts jam["title"]
  puts "by " + jam["artist"]

  jam["likesCount"].times {print "♥︎ "}
  # if jam["likesCount"] > 0
  #   {puts "&hearts; "}
  # end

  puts " "

#   puts "<div class='jam'>"
#   puts "<p class='title'><a href='" + jam["viaUrl"] + "'>" + jam["title"] + "</a></p>"
#   puts "<p class='artist'>by " + jam["artist"] + "</p>"

#   if jam["likesCount"] > 0
#     puts "<p class='likes'>" + jam["likesCount"].to_s + " &hearts; " + "</p>"
#   end

#   puts "</div>"

end

# puts "</body></html>"