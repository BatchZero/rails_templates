def source_paths
  [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')]
end

RUBY_VERSION = '2.1.0'

git :init

remove_dir 'test'

run 'touch .ruby-version'
append_file '.ruby-version', RUBY_VERSION

remove_file 'Gemfile'
template 'Gemfile'
remove_file '.gitignore'
template '.gitignore'
remove_file 'README.rdoc'
template 'README.md.erb', 'README.md'

inside 'config' do
  config = <<-RUBY
    config.generators do |generate|
      generate.helper false
      generate.request_specs false
      generate.routing_specs false
      generate.test_framework :rspec
      generate.view_specs false
    end

  RUBY
  inject_into_class 'application.rb', 'Application', config

  inside 'environments' do
    config = <<-RUBY

  # Enable deflate / gzip compression of controller-generated responses
  config.middleware.use Rack::Deflater
    RUBY

    inject_into_file 'production.rb', config,
      :after => "config.serve_static_assets = false\n"
  end

  template 'database.yml', force: true
  template 'unicorn.rb'
  template 'i18n-tasks.yml'

  inside 'initializers' do
    file 'secret_token.rb', <<-RUBY
      #{@app_const}.config.secret_key_base = ENV['SECRET_TOKEN'] || "A" * 20
    RUBY
  end

  inside 'locales' do
    remove_file 'en.yml'
    template 'en.yml'
  end

  remove_file 'secrets.yml'
end

inside 'app' do
  inside 'views' do
    inside 'layouts' do
      template 'application.html.erb', force: true
    end

    inside 'shared' do
      template '_flashes.html.erb'
    end
  end
end

# Generate .env files
db_user = ask('What is your DB_USER?')
db_pass = ask('What is your DB_PASS?')

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

generate 'rspec:install'

inside 'spec' do
  remove_file 'spec_helper.rb'
  template 'spec_helper.rb'
  template 'i18n_spec.rb'
  inside 'support' do
    template 'database_cleaner.rb'
    template 'factory_girl_rspec.rb'
  end
  empty_directory_with_keep_file 'features'
  empty_directory_with_keep_file 'helpers'
  empty_directory_with_keep_file 'factories'
  empty_directory_with_keep_file 'models'
  empty_directory_with_keep_file 'controllers'
end

append_file 'Rakefile' do
  "task(:default).clear\ntask :default => [:spec]\n"
end

rake 'db:create db:migrate'
rake 'db:create db:migrate RAILS_ENV=test'

git add: '.'
git commit: %Q{ -m 'Initial commit' -q }
