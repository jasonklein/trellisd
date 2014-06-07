# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.delete_all

categories = Category.create([
  {name: 'Activity', icon: ''},
  {name: 'Collab', icon: ''},
  {name: 'Housing', icon: ''},
  {name: 'Knowledge and Miscellaneous', icon: ''},
  {name: 'PDQ', icon: ''},
  {name: 'Romance', icon: ''},
  {name: 'Stuff', icon: ''},
  {name: 'Travel', icon: ''},
  {name: 'Work', icon: ''}
  ])