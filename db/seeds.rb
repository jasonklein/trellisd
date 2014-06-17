# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Category.delete_all
Keyword.delete_all

User.create(
  first_name: "Jason",
  last_name: "Jason",
  email: "jason@example.com",
  bio: "I once licked a man in Reno just to watch him smile.",
  birthday: '1982-04-06',
  city: "London",
  postcode: "E8",
  password: 'jimmies!',
  password_confirmation: 'jimmies!',
  role: :admin
  )

categories = Category.create([
  {title: 'Activity'},
  {title: 'Collab'},
  {title: 'Housing'},
  {title: 'Knowledge and Miscellaneous'},
  {title: 'PDQ'},
  {title: 'Romance'},
  {title: 'Stuff'},
  {title: 'Travel'},
  {title: 'Work'}
  ])

keywords = Keyword.create([
  {title: 'web developer'},
  {title: 'ruby'},
  {title: 'ruby on rails'},
  {title: 'git'},
  {title: 'github'},
  {title: 'html'},
  {title: 'css'},
  {title: 'scss'},
  {title: 'haml'},
  {title: 'remote'},
  {title: 'project management'},
  {title: 'tdd'},
  {title: 'agile'},
  {title: 'javascript'},
  {title: 'pair programming'},
  {title: 'jquery'},
  {title: 'junior developer'},
  {title: 'senior developer'},
  {title: 'nodejs'},
  {title: 'full stack'}
  ])