require 'seeder'
desc "Seed the database with Thousands of records"
task :populate_db => :environment do
  Seeder.build_mega_db
end
