namespace :db do desc "Backup project database. Options: DIR=backups RAILS_ENV=production MAX=7"
  task :backup => [:environment] do
    datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    base_path = Rails.root
    base_path = File.join(base_path, ENV["DIR"] || "backups")
    backup_base = File.join(base_path, 'db_backups')
    backup_folder = File.join(backup_base, datestamp)
    backup_file = File.join(backup_folder, "#{RAILS_ENV}_dump.sql")
    FileUtils.mkdir_p(backup_folder)
    db_config = ActiveRecord::Base.configurations[RAILS_ENV]
    `mysqldump -u #{db_config['username']} -p#{db_config['password']} -i -c -q #{db_config['database']} > #{backup_file}`
    raise "Unable to make DB backup!" if ( $?.to_i > 0 )
    `gzip -9 #{backup_file}`
    dir = Dir.new(backup_base)
    all_backups = dir.entries.sort[2..-1].reverse
    puts "Created backup: #{backup_file}"
    max_backups = (ENV["MAX"].to_i if ENV["MAX"].to_i > 0) || 100
    unwanted_backups = all_backups[max_backups..-1] || []
    for unwanted_backup in unwanted_backups
      FileUtils.rm_rf(File.join(backup_base, unwanted_backup))
    end
    puts "Deleted #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available"
  end
end

# USAGE
# =====
# rake db:backup
# RAILS_ENV=production rake db:backup
# MAX=14 RAILS_ENV=production rake db:backup
# DIR=another_dir MAX=14 RAILS_ENV=production rake db:backup


