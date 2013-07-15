# Given a listing of files in an S3 bucket, get the relevant info and create a podcast.xml file from them.
# sample listing
# note: exclude podcast file itself!

BEGIN {
  date -R | getline d
  print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  print "<rss version=\"2.0\">"
  
  print "<channel>"

  print "<title>My Radio Podcast</title>"
  print "<description>Slurped internet radio</description>"
  print "<link>http://dfsradiopodcast.s3-website-us-east-1.amazonaws.com</link>"
  print "<language>en-us</language>"
  print "<copyright>Copyright 2013</copyright>"
  print "<lastBuildDate>" d "</lastBuildDate>"
  print "<pubDate>" d "</pubDate>"
  print "<webMaster>derrick.schneider@gmail.com</webMaster>"
}

!/podcast\.xml/ {
  print "<item>"
  line_date = $1" "$2
  size = $3
  url = substr($0, index($0,$4)) # get the last n fields
  split(url,url_components,"/")
  file = url_components[4]
  directory = url_components[3]
  
  print "<title>" file "</title>"
  print "<link>" url "</link>"
  print "<guid>" url "</guid>"
  print "<description>" line_date "</description>"
  print "<enclosure url=\"http://s3.amazonaws.com/" directory "/" file "\" length=\"" size "\" type=\"audio/mpeg\"/>"
  print "<category>Podcasts</category>"
  print "<pubDate>" line_date " -0000</pubDate>"
  print "</item>"
}

END {
  print "</channel>"
  print "</rss>"
}
