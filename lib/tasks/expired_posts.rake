desc "Remove expired posts."
task :expired_posts => :environment do

  ### Won't delete posts with recent matches
  ### unless very expired.

  expired_posts = Post.where('expiration < ?', Date.today)
  expired_posts.each do |expired_post|
    if expired_post.has_recent_matches
      if expired_post.expiration < 5.days.ago.to_date
        expired_post.destroy
      end
    else
      expired_post.destroy
    end
  end
end
