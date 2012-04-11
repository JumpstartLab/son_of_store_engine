# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(:name => "Matt Yoho",
            :email => "matt.yoho@livingsocial.com",
            :password => "hungry")
User.create(:name => "Jeff Casimir",
            :email => "jeff.casimir@livingsocial.com",
            :display_name => "j3",
            :password => "hungry")
admin = User.new( :name => "Chad Fowler",
                  :email => "chad.fowler@livingsocial.com",
                  :display_name => "SaxPlayer",
                  :password => "hungry")
admin.is_admin = true
admin.save