class StoreTweet
  include Sidekiq::Worker
  def client
    acc = ACCOUNTS.shuffle.first
    puts acc
    Twitter::REST::Client.new do |config|
      config.consumer_key        = CONSUMER_KEY
      config.consumer_secret     = CONSUMER_SECRET
      config.access_token        = acc.oauth_token
      config.access_token_secret = acc.oauth_token_secret
    end
  end

  def perform(id)
    t = JSON.parse(client.status(id).to_json)
    t.created_at = Time.parse(t.created_at)
    t.user.created_at = Time.parse(t.user.created_at)
    t.twitter_id = t.id
    t.delete("id")
    Tweet.first_or_create(twitter_id: t.twitter_id).update_attributes(t)
  end
end
