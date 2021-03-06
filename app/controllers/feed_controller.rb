require_dependency File.join(THEME_DIR, 'theme_helper')

class FeedController < ApplicationController
  helper :feed, :tumble, ThemeHelper
  caches_page :atom, :rss, :burner
  session :off
  
  # the feed method.
  def feed
    @posts = Post.find(:all, :order => 'id DESC', :limit => 10) 
  end
  
  # cache the full output of the rss and atom methods.
  # this is a disk based cache, with the files stored in yourapp/public/feeds.
  # atom and rss methods are both identical, they just call the feed method.
  %w[atom rss].each do |f| 
    define_method(f.to_sym) { feed }
    caches_page f.to_sym
  end

  def burner
    feed
    render :action => :atom
  end
end
