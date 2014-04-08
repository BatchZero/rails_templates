def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')]
end

git :init

remove_dir "test"

run "touch .ruby-version"
append_file ".ruby-version", ENV['RUBY_VERSION']

remove_file "Gemfile"
template "root/Gemfile", "Gemfile"

run "bundle install"

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

generate(:controller, "pages") if yes?("Generate static pages controller? [Yn]")

generate "rspec:install"

rake "db:create"
rake "db:migrate"
rake "db:test:prepare"

git add: "."
git commit: %Q{ -m 'Initial commit' }
