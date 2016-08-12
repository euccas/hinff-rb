# Inflib

inflib: A ruby gem handles common trivias and makes everyday ruby programming easier.

*Ruby -- "The best friend of programmers."*

*inflib -- "The best friend of Ruby programmers :)"* 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'inflib'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inflib

## Modules

### common/utils
  - Common helper functions
  - Update envrionment variables
  - Get time stamps
  - Check file/directory availability
  - Handle exit

### common/db_pg
  - Helper functions for PostgreSQL database
  - Connect to database
  - Check if database or table exists
  - Process database tables

### common/email
  - Helper functions for Emails
  - Send email (SMTP)

### common/lsf
  - Helper functions for LSF
  - Submit LSF jobs (bsub)
  - Monitor LSF jobs

### common/perforce
  - Helper functions for Perforce
  - Perforce login

### usecase
  - Helper functions for specific use cases
  - Tests related

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/inflib/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
=======


