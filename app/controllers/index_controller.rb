class IndexController < ApplicationController

  include ActionController::Live

  def stream
    topics = ["おちんちん", "おっぱい","ちんちん"]
    response.headers['Content-Type'] = 'text/event-stream; charset=utf-8'

  begin
    twitter_streaming.filter(:track => topics.join(",")) do |tweet|

    response.stream.write("#{tweet.user.name}") if tweet.lang == "ja" && !tweet.text.index("RT")
    puts tweet.text
    response.stream.write("(@#{tweet.user.screen_name})\n")
    response.stream.write("=>") unless tweet.user.name != ""

    response.stream.write("#{tweet.text}\n") if tweet.lang == "ja" && !tweet.text.index("RT")
    response.stream.write("-----------------------------------------------------------\n")
    end
#  rescue Twitter::Error::TooManyRequests => error
#    delay = error.rate_limit.reset_in || 180
#    sleep delay + 1
#    stream
    rescue IOError

    ensure
      response.stream.close
    end
  end

  private

  def twitter_streaming
    Twitter::Streaming::Client.new do |config|
      config.consumer_key        = "rb32nV03vQc6dy4NdSKH8bUBk"
      config.consumer_secret     = "AienTn6bYGiYjn1ihSbPSxgIIIqp49DqiACmTFW99JbtTxxbka"
      config.access_token        = "3044017777-JLlfdjxct10zRoYEf8OazTDqfaH2pKNENDdpQLn"
      config.access_token_secret = "ca9p1tMSZiM7TMrcWRBvzWzS30KB1kAfGM2TWuYLl57RP"
    end
  end
end
