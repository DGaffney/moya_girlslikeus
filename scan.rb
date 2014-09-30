#We need the Time library so we can make sense of things like "2012-03-01" and turn it into 2012-03-01 00:00:00 -0500
require 'time'
#Our start date is March 1, 2012
start_time = Time.parse("2012-03-01")
#for all of the files in the huge folder of all the tweets that Alan has ever collected, break that listing up into each filename (every filename looks like 'tweets.2012-03-01.gz')
`ls`.split("\n").each do |file|
  #parse the time of the file that we're looking at, and if we can't parse it for some reason, make that value nil (there are a few files like README.txt and other things that actually aren't tweet files in this directory)
  time = Time.parse(file.split(".")[1]) rescue nil
  #if we parsed the time, AND the time is later than March 1, 2012, then....
  if time && time >= start_time
    # Do some ~*magic*~ - the line below is a very nerdy line that says "please print out the unzipped file for this day of tweets, and for each tweet, select out any tweet that contains #girlslikeus, ignoring case sensitivity (eg. #GirlsLikeUs), then pump that value into the corresponding name of the file in /scratch/moya_bailey_girlslikeus_tweets/[whatever_day_this_is].tsv
    `zcat #{file} | grep '#girlslikeus' --ignore-case > /scratch/moya_bailey_girlslikeus_tweets/#{file.split(".")[1]}.tsv`
  #then we are... 
  end
#all done.
end
