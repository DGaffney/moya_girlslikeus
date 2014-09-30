require 'csv'
keys = [:twitter_id, :user_id, :time, :reply_tweet_id, :reply_user_id, :source, :truncated?, :geotag, :location, :text, :screen_name]
dataset = []
`ls moya_bailey_girlslikeus_tweets`.split("\n").each do |file|
  File.read("moya_bailey_girlslikeus_tweets/#{file}").split("\n").collect{|x| x.split("\t")}.each do |r|
    dataset << Hash[keys.zip(r)]
  end
end
f = CSV.open("moya_dataset.csv", "w")
f << keys
dataset.each do |r|
  f << keys.collect{|k| r[k]}
end
f.close