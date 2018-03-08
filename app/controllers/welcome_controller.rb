class WelcomeController < ApplicationController

  BASIC_TOPICS_URI = 'https://ruby-china.org/topics?page='
  BASIC_COMMENTS_URI = 'https://ruby-china.org/topics/'

  def index
  end

  def show_topics
    page = params[:page].to_i
    uri = BASIC_TOPICS_URI + page.to_s
    @topics = Mechanize.new.get(uri).search("div#main div.title a").to_a
    @users = Mechanize.new.get(uri).search("div#main div.info a").to_a
    @hrefs = Mechanize.new.get(uri).search("div#main div.title a").to_a
  end

  def show_comments
    topic_id = params[:topic_id]
    uri = BASIC_COMMENTS_URI + topic_id
    @comment_authors = Mechanize.new.get(uri).search("div#replies span.name a").to_a
    @comment_contents = Mechanize.new.get(uri).search("div#replies div.markdown p").to_a
  end
end
