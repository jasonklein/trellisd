namespace :match do
  desc "Find and make matches for fresh posts."
  task :fresh_posts => :environment do

    # This task should be raked 3-4 times per day

    fresh_posts = Post.where(created_at: 1.day.ago..Time.now)

    if fresh_posts.any?
      fresh_posts.each do |post|
        post.make_matches
      end
    end

  end

  desc "Find and make matches for aged posts."
  task :aged_posts => :environment do

    # This task should be raked 1 time per day.

    three_day_old_posts = Post.where(created_at: 3.days.ago..1.day.ago)
    one_week_old_posts = Post.where(created_at: 1.week.ago..3.days.ago)
    two_week_old_posts = Post.where(created_at: 2.weeks.ago..1.week.ago)
    one_month_old_posts = Post.where(created_at: 1.month.ago..2.weeks.ago)
    two_month_old_posts = Post.where(created_at: 2.months.ago..1.month.ago)
    three_month_old_posts = Post.where(created_at: (3.months.ago + 1.day)..2.months.ago)
    all_aged_posts = three_day_old_posts | one_week_old_posts | two_week_old_posts | one_month_old_posts | two_month_old_posts | three_month_old_posts

    if all_aged_posts.any?
      all_aged_posts.each do |post|
        post.make_matches
      end
    end
    
  end

end