class CleanTweetBundle
  include Sidekiq::Worker
  def perform
     ExtractGraphFromData.dataset.collect(&:twitter_id).collect{|id| StoreTweet.perform_async(id.to_i)}
  end
end
