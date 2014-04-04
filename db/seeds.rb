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

if User.count == 0 #create admin user
  puts "Creating admin user"
  User.create(:name=>"admin", :password=>'changeme', :password_confirmation => 'changeme', :role_id => Role.find_by_name('admin').id)
end

if not BenchmarkType.find_by_name("specInt2k")
  BenchmarkType.create(:name=>"specInt2k", :description=>"SPEC 2000 Benchmark for integer based computations")
end

if not BenchmarkType.find_by_name("HEPSPEC06")
  BenchmarkType.create(:name=>"HEPSPEC06", :description=>"HEP 2006 Benchmark for integer based computations")
end
if not BenchmarkType.find_by_name("specFloat2k")
  BenchmarkType.create(:name=>"specFloat2k", :description=>"SPEC 2000 Benchmark for floatin point based computations")
end
if not ResourceType.find_by_name("Farm_grid")
  ResourceType.create(:name=>"Farm_grid", :description=>"Pure GRID farm, no local jobs allowed")
end
if not ResourceType.find_by_name("Farm_local")
  ResourceType.create(:name=>"Farm_local", :description=>"Pure LOCAL farm, no grid jobs submittted to this farm")
end
if not ResourceType.find_by_name("Farm_grid+local")
  ResourceType.create(:name=>"Farm_grid+local", :description=>"Hybrid LOCAL and GRID farm. Both type of jobs allowed")
end
if not ResourceType.find_by_name("Database")
  ResourceType.create(:name=>"Database", :description=>"Relational Database")
end



