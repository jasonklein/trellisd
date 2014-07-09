namespace :match do
  desc "Find and make matches for fresh posts."
  task :fresh_posts => :environment do

    # This task is set to rake hourly, per Heroku scheduler options

    fresh_posts = Post.where(created_at: 1.day.ago..Time.now)

    if fresh_posts.any?
      fresh_posts.each do |post|
        post.make_matches
      end
    end
  end

  desc "Find and make matches for aged posts."
  task :aged_posts => :environment do

    # Set to rake nightly, per Heroku scheduler options

    # Intention is to reduce resource demands as posts age

    # Posts up to a week old get matched every night
    # Posts 10 days, 2 weeks, 3 weeks, 4 weeks, 6 weeks, 2 months, and 3 months old
    # get matched each night. This should mean that a post that is one month old,
    # should have been selected for match making, after the first day, 10 times
    # (depending on the month).

    up_to_a_week_old_posts = Post.where(created_at: 1.week.ago...1.day.ago)
    ten_day_old_posts = Post.where(created_at: 10.days.ago)
    two_week_old_posts = Post.where(created_at: 2.weeks.ago)
    three_week_old_posts = Post.where(created_at: 3.weeks.ago)
    four_week_old_posts = Post.where(created_at: 4.weeks.ago)
    six_week_old_posts = Post.where(created_at: 6.weeks.ago)
    two_month_old_posts = Post.where(created_at: 2.months.ago)
    three_month_old_posts = Post.where(created_at: 3.months.ago)
    all_aged_posts = up_to_a_week_old_posts | ten_day_old_posts | two_week_old_posts | three_week_old_posts | four_week_old_posts | six_week_old_posts | two_month_old_posts | three_month_old_posts
    all_aged_posts = all_aged_posts.uniq

    if all_aged_posts.any?
      all_aged_posts.each do |post|
        post.make_matches
      end
    end
  end
end