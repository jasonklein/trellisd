require_relative '../match_helper'
include MatchHelper

namespace :match do
  desc "Find and make matches for fresh posts."
  task :fresh_posts => :environment do

    # This task is set to rake hourly, per Heroku scheduler options

    fresh_posts = Post.where(created_at: 1.day.ago..Time.now)

    match_posts_and_notify_users(fresh_posts)
  end

  desc "Find and make matches for aged posts."
  task :aged_posts => :environment do

    # Set to rake nightly, per Heroku scheduler options

    # Intention is to reduce resource demands as posts age

    # On X day, rakes for given ages should be approximately:
    # one day old: 24 total rakes
    # one week old: 30 total rakes
    # one month old: 34 total rakes
    # two months old: 36 total rakes
    # three months old: 37 total rakes

    up_to_a_week_old_posts = Post.where(created_at: 1.week.ago..1.day.ago)
    ten_day_old_posts = Post.where(created_at: 11.days.ago..10.days.ago)
    two_week_old_posts = Post.where(created_at: 15.days.ago..14.days.ago)
    three_week_old_posts = Post.where(created_at: 22.days.ago..21.days.ago)
    four_week_old_posts = Post.where(created_at: 29.days.ago..28.days.ago)
    six_week_old_posts = Post.where(created_at: 43.days.ago..42.days.ago)
    two_month_old_posts = Post.where(created_at: 61.days.ago..60.days.ago)
    three_month_old_posts = Post.where(created_at: 91.days.ago..90.days.ago)
    all_aged_posts = up_to_a_week_old_posts | ten_day_old_posts | two_week_old_posts | three_week_old_posts | four_week_old_posts | six_week_old_posts | two_month_old_posts | three_month_old_posts
    all_aged_posts = all_aged_posts.uniq

    puts all_aged_posts.count

    match_posts_and_notify_users(all_aged_posts)

  end
end