desc "Remove expired posts."
task :expired_posts => :environment do

  expired_posts = Post.where('expiration < ?', Date.today)
  expired_posts.each do |expired_post|
    expired_post.destroy unless expired_post.has_recent_matches?
  end
end
