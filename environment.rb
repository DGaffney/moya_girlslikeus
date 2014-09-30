require 'pry'
require 'csv'
require 'sinatra'
require 'iconv'
require 'twitter'
require 'twitter-text'
require 'mongo_mapper'
require 'sidekiq'
require 'sinatra'
Dir[File.dirname(__FILE__) + '/extensions/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/graph/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/workers/*.rb'].each {|file| require file }
MongoMapper.connection = Mongo::MongoClient.new("127.0.0.1", :pool_size => 25, :pool_timeout => 60)
MongoMapper.database = "moya"

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end
CONSUMER_KEY = "gkkhB8zthzG622bt9x0C3w"
CONSUMER_SECRET = "2xB6Jwvi24uDQCK6Y3b9WwlxGsQLeSkceVN6LDV2R4"

ACCOUNTS = [{ _id: "516115e4e99133373500000c", screen_name: "DGaff", oauth_token: "13731562-kw1GROgsjtQ9hsjgLVbWJuFTI8PfRkLsazK9raP6Y", oauth_token_secret:"2HZmhaMhfPiNi4egJO1dbnYEaFB8uFBmuL7f5wFglU"},
{ _id: "5161160ee991333735000023", screen_name: "peat", oauth_token: "3658721-LMKPKKYl7kTLkYJel3KxkWs3JJ4oMMXyY6ed0KTpbo", oauth_token_secret:"ZKJBKPqepcyTORpK5APEtoRvXjEknWKVW93A9W34n8"},
{ _id: "51620d51e99133531a000052", screen_name: "DGaff", oauth_token: "13731562-kw1GROgsjtQ9hsjgLVbWJuFTI8PfRkLsazK9raP6Y", oauth_token_secret:"2HZmhaMhfPiNi4egJO1dbnYEaFB8uFBmuL7f5wFglU"},
{ _id: "5160f2cfe9913330a8000007", screen_name: "DGaff", oauth_token: "13731562-kw1GROgsjtQ9hsjgLVbWJuFTI8PfRkLsazK9raP6Y", oauth_token_secret:"2HZmhaMhfPiNi4egJO1dbnYEaFB8uFBmuL7f5wFglU"},
{ _id: "51635c20e99133439d000456", screen_name: "Mikalina", oauth_token: "5383262-e2CGKbeoQM7GOXE7Lc7gtEz8IYpAPCmNZJiw94BNSM", oauth_token_secret:"jbF5TktfYMGbhBgShpyHkj0nEUp16uDLgBziE4FXOQU"},
{ _id: "51635c5be99133439d000464", screen_name: "peat", oauth_token: "3658721-LMKPKKYl7kTLkYJel3KxkWs3JJ4oMMXyY6ed0KTpbo", oauth_token_secret:"ZKJBKPqepcyTORpK5APEtoRvXjEknWKVW93A9W34n8"},
{ _id: "51635cbae99133439d0004cf", screen_name: "marshallk", oauth_token: "818340-rUYxRxQOlx30OMIdX1oCdXwVKnHwb2v3ZNdUana2Ys", oauth_token_secret:"wb0wRim9h0h0oxbgO0xJVmG0yUY3RNhjUBJYFoH5p0"},
{ _id: "51635d90e99133439d0004dd", screen_name: "parakweets", oauth_token: "1002926077-5JLYlSk2VBzlYbctia9Ii5nYDnqGvA7kHVQZra6", oauth_token_secret:"ZwY63LJmwjtCjLTH7uJ2KBvfHNO3nO5ZXfdTwPm12tU"},
{ _id: "51635de8e99133439d0004eb", screen_name: "tylergillies", oauth_token: "9429332-zNwPcF62SRm207qCqOCIX4H8IyWziXPJwbsolxbosQ", oauth_token_secret:"zzC8o3b2xwMBn0TLof6vG8qQ2NsBX6uWAZzJk83fBk"},
{ _id: "5165de51e991335edb000846", screen_name: "TheTadpole", oauth_token: "27739180-1RJmr3NnA8ji4LYYE4OM9awQ8bQZPy7IxjpDpuYFC", oauth_token_secret:"by6wfcD1TJroqfaloZRiRVSTAarIzRdXqiomX3Bsk"},
{ _id: "5165e01ce991335edb000866", screen_name: "MonteraRSP", oauth_token: "350663846-RrK7lJAnggg7YdPBnJNPu3QMgX3b3iUVrxGA3Zhy", oauth_token_secret:"4dAaZknoxnsccbPQyA2cCK0KRBQmAaCOEWhBD7jpRPw"},
{ _id: "5165e1f0e991335edb000880", screen_name: "Davoodi_", oauth_token: "281904509-fM82lTMgjTJ4oF1gEzd7XT3J7XnWei4MlhvOTMqF", oauth_token_secret:"gucF8zj7GuJk3OlfW8IW54DhygSs1c7LSfwY6x53Pfg"},
{ _id: "5165e255e991335edb000898", screen_name: "bluesungod", oauth_token: "76999819-hJcXQeh1I4YYuaiBSoI3ZPKhN289uwVLo74xdb82t", oauth_token_secret:"KKfDe8DyJVIw7fpH9CBWabqCVDGYJrZhJoXVVUZzo"},
{ _id: "5165e2ebe991335edb0008a9", screen_name: "photoxlove", oauth_token: "17826713-I6qz0LXvFOYlyRb9U0YCeImm3br41JU2SLPs5S5jz", oauth_token_secret:"0LOGH1jT33vF9Ysz8lAG3qYIZOLPOAWnRokhAbKXoQ"},
{ _id: "5165e425e991335edb0008ba", screen_name: "weitzmand", oauth_token: "41149246-7CySTRal5qAkiUSB9cGXIVRyZzhBQc90PpkVQjuxP", oauth_token_secret:"8vEOsBKXgbbrtn8eQrMGT6EI14vbuX0eH40JAFgYXo"},
{ _id: "5165e48be991335edb000963", screen_name: "gleuch", oauth_token: "6486742-yYEqhzj5BBGZeALTekmtQvSK38MncBtsUuuaK8ceNx", oauth_token_secret:"l8B8q1xcReqVgl9j3KqPBuWoKwJalC5JfcXs3v0IGc"},
{ _id: "5165e7f8e991335edb0009b3", screen_name: "tedhendershot", oauth_token: "50496562-FLtXw6aUydHsvK29cUmoE3lxyTcOcXmJhtCX5IH28", oauth_token_secret:"Fqu9xeB3PCV0F1p5DvGvXMGRjHPxDQvmGsuAYPXnN3I"},
{ _id: "5165eaf6e991335edb0009db", screen_name: "henry_lyon", oauth_token: "18766302-oagdARZIDKeZEN5RE52idm5iWscv7GcCCQ0i8RTiQ", oauth_token_secret:"q2lDGvO4H5iKqvUWQPCMNAE3Ckh0vUO7R527H9Vgvo"},
{ _id: "5165f0e2e991335edb0009f7", screen_name: "TonneliAnais", oauth_token: "1019270856-lx5Ir8Nlj4ClonC6MRQmQcWcOsSgwVIpLp8BQts", oauth_token_secret:"eNLj8zHRVDdiV89fvuwbLPQQTJ2LP4S8PcKH92dkwY"},
{ _id: "5165f25ce991335edb000a08", screen_name: "ryaniscool", oauth_token: "14518954-iC3iXaSAhH801y8kpC9AWZILxY8ZjWTVAbw3FvaE", oauth_token_secret:"f0fMLcwf3kMUtUvxScJ32aErHvqYhVwOxO8hssz37M"},
{ _id: "51662aede9913378ab000018", screen_name: "Farbodd", oauth_token: "15259715-6I2UFcO0I1aFAMUwGjnE7wsEfpu8t8wneBbqKsIdA", oauth_token_secret:"ZUF4gGGNp6WDIKyZ7mdE2V7uAfR1I8AZiKAml6g5SDs"},
{ _id: "51663c05e9913378ab0002bd", screen_name: "Radu20", oauth_token: "37503540-Lwg52pXYdIamRkHfFcsf3IDYf3cRDrE28ayvVD9Sv", oauth_token_secret:"LLtsOotIjSWNCpxAp13mJKYndYSFVFQ26NxAkzd40"},
{ _id: "5166911be9913378ab00042c", screen_name: "LexingtonBA", oauth_token: "990615936-mVvRvVoJy6vpmpImsEO2jkjM9Ewusj0JHUF1UjJo", oauth_token_secret:"frYU7JaleuVP0EFuISUDEYQVZdm8qzBqea4Ex61E"},
{ _id: "51a5f88fe991335d9600455f", screen_name: "DGaff", oauth_token: "13731562-kw1GROgsjtQ9hsjgLVbWJuFTI8PfRkLsazK9raP6Y", oauth_token_secret:"2HZmhaMhfPiNi4egJO1dbnYEaFB8uFBmuL7f5wFglU"}]
