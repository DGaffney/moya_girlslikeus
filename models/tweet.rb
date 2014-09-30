class Tweet
  include MongoMapper::Document
  key :created_at, Time
  key :id, Integer
  key :id_str, String
  key :text, String
  key :source, String
  key :truncated, Boolean
  key :in_reply_to_status_id, Integer
  key :in_reply_to_status_id_str, String
  key :in_reply_to_user_id, Integer
  key :in_reply_to_user_id_str, String
  key :in_reply_to_screen_name, String
  key :user, Hash
  key :geo
  key :coordinates
  key :place
  key :contributors
  key :retweeted_status, Hash
  key :retweet_count, Integer
  key :favorite_count, Integer
  key :entities, Hash
  key :extended_entities, Hash
  key :favorited, Boolean
  key :retweeted, Boolean
  key :possibly_sensitive, Boolean
  key :lang, String
end
