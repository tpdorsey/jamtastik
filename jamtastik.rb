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

    $jams << [jam["title"],jam["artist"],jam["likesCount"]]

    # puts "<div class='jam'>"
    # puts "<p class='title'>\"<a href='" + jam["viaUrl"] + "'>" + jam["title"] + "</a>\"</p>"
    # puts "<p class='artist'>by " + jam["artist"] + "</p>"

    # if jam["likesCount"] > 0
    #   puts "<p class='likes'>" + jam["likesCount"].to_s + " &hearts; " + "</p>"
    # end

    # puts "</div>"

  end

  if json_hash["list"]["hasMore"]
    getJams(json_hash["list"]["next"])
  end
end

userName = ARGV[0].split("/")[4]

# puts "<!doctype html><html><head>"
# puts "</head><body>"
# puts "<h1>Jams by " + userName + "</h1>"
getJams(ARGV[0])

# puts "</body></html>"

$jams.reverse!

$jams.each do |jam|
  puts ('*' * jam[2])
end