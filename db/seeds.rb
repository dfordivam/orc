# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
user = User.new({:username => 'superadmin' , :email => 'superadmin@gmail.com',
    :password => 'orc-demo', :password_confirmation => 'orc-demo', :role_id => 1})
begin
  puts "Superadmin Registration successful." if user.save
rescue Exception => e
  puts "Error: #{e}"
end