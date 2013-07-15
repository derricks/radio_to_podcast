# Given a listing of files in an S3 bucket, get the relevant info and create a podcast.xml file from them.
# sample listing
# note: exclude podcast file itself!

# 2013-01-12 16:21   1378512   s3://dfsradiopodcast/12-01-2013 08h 19m 36s.mp3
# 2013-01-12 16:22 165163104   s3://dfsradiopodcast/anna_bolena_(met,_feb._4_2012).mp3
# 2013-01-12 16:48 198042192   s3://dfsradiopodcast/faust_(met,_dec._10,_2011).mp3
# 2013-01-12 17:19 219658176   s3://dfsradiopodcast/gotterdammerung_(sf_opera,_12-04-2011).mp3
# 2011-12-03 14:26 244829088   s3://dfsradiopodcast/la_gioconda_(friday_night_at_the_opera).mp3
# 2012-02-07 03:52      5095   s3://dfsradiopodcast/podcast.xml
# 2011-12-03 22:05 198087120   s3://dfsradiopodcast/rodelinda_(met,_dec._3,_2011_).mp3
# 2013-07-14 16:03  39392000   s3://dfsradiopodcast/test1.mp3
# 2013-07-14 16:15  10864000   s3://dfsradiopodcast/test2.mp3
# 2011-12-03 15:11  12040704   s3://dfsradiopodcast/test_kdfc_music.mp3
# 2010-09-28 20:05   2572119   s3://dfsradiopodcast/tuesday_morning_test_3.mp3
# 2010-09-28 20:05   2625618   s3://dfsradiopodcast/tuesday_morning_test_4.mp3
# 2010-09-28 20:05   2628544   s3://dfsradiopodcast/tuesday_morning_test_5.mp3
# 2010-09-28 20:05   2503992   s3://dfsradiopodcast/tuesday_morning_test_7.mp3
# 2010-09-28 20:05   2575045   s3://dfsradiopodcast/tuesday_morning_test_8.mp3
# 2010-09-28 20:05   1940544   s3://dfsradiopodcast/tuesday_morning_test_9.mp3

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
