namespace :db do


  desc "Drop, create, migrate and fill database (including seeds)"
  task :populate => [:environment, :drop, :create, :migrate, :seed] do
    require 'faker'

    [Post, KeywordsPosts, Connection, Match].each(&:delete_all)

    # Create Users

    19.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      User.create(
        first_name: first_name,
        last_name: last_name,
        email: Faker::Internet.email(last_name + "." + first_name),
        bio: Faker::Lorem.sentence,
        birthday: '1982-04-06',
        city: Faker::Address.city,
        postcode: Faker::Address.postcode,
        password: 'jimmies!',
        password_confirmation: 'jimmies!',
        role: 'basic'
      )
    end

    # Create posts in the "Work" category.

    50.times do
      Post.create(
        category_id: Category.where(title: 'Work').first.id,
        title: Faker::Lorem.sentence,
        content: Faker::Lorem.paragraph,
        user_id: (1..20).to_a.sample,
        expiration: Date.today + 7.weeks
        )
    end

    # Create KeywordsPosts's

    200.times do
      KeywordsPosts.create(
        keyword_id: (1..20).to_a.sample,
        post_id: (1..50).to_a.sample
        )
    end

    # Create Connections

    i = 1
    while i <= 20 do

      # Make array of all of the id's but the one that will be assigned to the connecter.
      
      connectee_ids = (1..20).to_a.reject { |n| n == i }
      
      # Shuffle the array and assign the index to the connectee_id as the index increments
      # This is to avoid the connecter having multiple connections with the same connectee

      connectee_ids = connectee_ids.shuffle!
      for x in (0..4)
        Connection.create(
          connecter_id: i,
          connectee_id: connectee_ids[x]
          )
      end
      i += 1
    end
  end
end