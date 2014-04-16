# Accelerate

Collection of different Rails Application templates to bootstrap new projects.

Inspired by [thoughtbot/suspenders](https://github.com/thoughtbot/suspenders) but not a gem.

## Usage

Make sure you have rails installed to run `rails new`.

    gem install rails

To use the `rails-base` template, run

    rails new project_name -m https://github.com/BiteKollektiv/accelerate/raw/master/rails-base/rails-base.rb

By default this will create a new git repository and a functional Rails Application.

There might be some dependencies missing, depending on your system.

## Gemfile

Application gems

 * [jQuery Rails](https://github.com/rails/jquery-rails) for jQuery
 * [Postgres](https://github.com/ged/ruby-pg) for access to the Postgres database
 * [Unicorn](http://unicorn.bogomips.org/) to serve HTTP requests
 * [Rails 12 Factor](https://github.com/heroku/rails_12factor) to make running Rails 4 apps easier on Heroku
 * [rails-i18n](https://github.com/svenfuchs/rails-i18n) to manage locales

Development gems

 * [Dotenv](https://github.com/bkeepers/dotenv) for loading environment variables
 * [Pry Rails](https://github.com/rweng/pry-rails) for debugging
 * [Spring](https://github.com/rails/spring) for fast Rails actions via pre-loading

Testing gems

 * [Capybara](https://github.com/jnicklas/capybara) for integration testing
 * [Factory Girl](https://github.com/thoughtbot/factory_girl) for test data
 * [RSpec](https://github.com/rspec/rspec) for unit testing
 * [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for common RSpec matchers

## More stuff


 * Rails' flashes set up and in application layout
 * A few nice time formats set up for localization
 * [Rack::Deflater](https://github.com/rack/rack/blob/master/lib/rack/deflater.rb) to compress responses with Gzip
 * [Fast-failing factories](https://github.com/thoughtbot/factory_girl/commit/6a692fe711a43f3654480190af3110533786c29b)

     

Just like Suspenders, Accelerate fixes several of Rails' insecure defaults:

 * Accelerate uses Unicorn instead of WEBrick, allowing less verbose Server headers.
 * Accelerate is configured to pull your application secret key base from an environment variable, which means you won't need to risk placing it in version control.

