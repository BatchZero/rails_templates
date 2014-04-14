def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')]
end

RUBY_VERSION = "2.1.0"

git :init

remove_dir "test"

run "touch .ruby-version"
append_file ".ruby-version", RUBY_VERSION.to_s

remove_file "Gemfile"
template "root/Gemfile", "Gemfile"

inside 'config' do
  remove_file 'database.yml'
  template 'database.yml'
end

# Generate .env files
db_user = ask("What is your DB_USER?")
db_pass = ask("What is your DB_PASS?")

file '.env.development', <<-TEXT
SECRET_TOKEN=#{ %x{ rake secret } }
DB_NAME=#{@app_name}_development
DB_USER=#{db_user}
DB_PASSWORD=#{db_pass}
TEXT

file '.env.test', <<-TEXT
SECRET_TOKEN=#{ %x{ rake secret } }
DB_NAME=#{@app_name}_test
DB_USER=#{db_user}
DB_PASSWORD=#{db_pass}
TEXT

generate "rspec:install"

inside 'spec' do
  remove_file 'spec_helper.rb'
  template 'spec_helper.rb'
  inside 'support' do
    template 'database_cleaner.rb'
  end
end

rake "db:create"
rake "db:migrate"

git add: "."
git commit: %Q{ -m 'Initial commit' }

run "cd #{@app_name}"
