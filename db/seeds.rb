# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
if Role.count == 0
  puts "Creating admin and user role"
  Role.create(:name=>"admin", :description => 'Administrative account')
  Role.create(:name=>"user", :description => 'Simple user account')
end

if User.count == 0
  puts "Creating admin user"
  User.create(:name=>"admin", :password=>'changeme', :password_confirmation => 'changeme')
end