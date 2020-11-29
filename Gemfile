source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gemspec

rails_version = "#{ENV['RAILS_VERSION'] || '~> 6.0'}"

gem "rails", rails_version == "master" ? { github: "rails/rails" } : rails_version
gem "oj"
