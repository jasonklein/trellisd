namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'

    [User, Category, Keyword, Post, KeywordsPosts, Connection].each(&:delete_all)

    20.times do
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
        image: 'http://www.example.com'
      )
    end
  end
end