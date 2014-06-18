namespace :db do


  desc "Drop, create, migrate and fill database (including seeds)"
  task :populate => [:environment, :drop, :create, :migrate, :seed] do
    require 'faker'

    [Post, KeywordsPosts, Connection, Match].each(&:delete_all)

    # Create Users

    39.times do
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
        role: :basic
      )
    end

    # Create posts and add keywords.

    category_ids = Category.all.map { |category| category.id }
    potential_keyword_titles = Keyword.all.map { |keyword| keyword.title }

    300.times do
      post = Post.new(
        category_id: category_ids.sample,
        title: Faker::Lorem.sentence,
        content: Faker::Lorem.paragraph,
        user_id: (1..20).to_a.sample,
        expiration: Date.today + 7.weeks,
        directionality: [:seeking, :offering].sample
        )
      keywords_amount = rand(3..7)
      keyword_titles = potential_keyword_titles.shuffle.slice(0..keywords_amount)
      post.add_keywords(keyword_titles)

      post.save
    end

    # Create Connections

    i = 1
    while i <= 40 do

      # Make arrays of all of the id's but the one that
      # will be assigned to the connecter. Two arrays to
      # increase likelihood of tertiary connections
      # (a person C who is connected to B and not A)
      
      connectee_ids_a = (1..25).to_a.reject { |n| n == i }
      connectee_ids_b = (16..40).to_a.reject { |n| n == i }

      # Shuffle the array and assign the index to the connectee_id as the index increments
      # This is to avoid the connecter having multiple connections with the same connectee

      connectee_ids = [connectee_ids_a, connectee_ids_b].sample.shuffle!
      for x in (0..5)
        Connection.create(
          connecter_id: i,
          connectee_id: connectee_ids[x],
          state: :accepted
          )
      end
      i += 1
    end
  end
end