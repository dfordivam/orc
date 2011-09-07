namespace :superadmin  do
  desc "Create Super Admin"
  task :superadmin_credentials => :environment do
    user = User.new({:username => 'superadmin' , :email => 'superadmin@gmail.com',
        :password => 'orc-123', :password_confirmation => 'orc-123', :role_id => 1})
    begin
      puts "Superadmin Registration successful." if user.save
    rescue Exception => e
      puts "Error: #{e}"
    end
  end
end