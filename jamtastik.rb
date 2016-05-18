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

archive_mode = false
jammer = ""

if ARGV[0] == "-archive" || ARGV[0] == "-a"
  archive_mode = true
  jammer = ARGV[1]
else
  jammer = ARGV[0]
end

api_uri = "http://api.thisismyjam.com/1/" + jammer + "/jams.json"

puts "<!doctype html><html><head>"
puts "<title>" + jammer + "'s ThisIsMyJam Jams</title>"
puts "</head><body>"
puts "<h1 class='title'>Jams by " + jammer + "</h1>"

getJams(api_uri)

puts "<p class='subtitle'>" + $jams.length.to_s + " jams since " + $jams.last["creationDate"] + "</p>"

$jams.each do |jam|

  # puts jam["title"]
  # puts "by " + jam["artist"]

  # jam["likesCount"].times {print "♥︎ "}
  # if jam["likesCount"] > 0
  #   {puts "&hearts; "}
  # end

  puts " "

  puts "<div class='jam'>"
  puts "<img src='" + jam["jamvatarMedium"] + "'>"
  puts "<p class='title'><a href='" + jam["viaUrl"] + "'>" + jam["title"] + "</a></p>"
  puts "<p class='artist'>by " + jam["artist"] + "</p>"
  puts "<p class='source'>via " + jam["via"] + "</p>"

  print "<p class='likes'>&#9835;: "
  print jam["playCount"].to_s
  print "  &hearts;: "
  # heavy heart: &#10084;
  print jam["likesCount"].to_s
  print "  &#9998;: "
  print jam["commentsCount"].to_s
  puts "</p>"

  puts "</div>"

end

puts "</body></html>"