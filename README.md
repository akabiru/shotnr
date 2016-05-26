[![Build Status](https://travis-ci.org/andela-akabiru/shotnr.svg?branch=master)](https://travis-ci.org/andela-akabiru/shotnr) [![Coverage Status](https://coveralls.io/repos/github/andela-akabiru/shotnr/badge.svg?branch=master)](https://coveralls.io/github/andela-akabiru/shotnr?branch=master) [![Code Climate](https://codeclimate.com/github/andela-akabiru/shotnr/badges/gpa.svg)](https://codeclimate.com/github/andela-akabiru/shotnr)

# Shotnr

![](https://www.dropbox.com/s/aq4fxsoj5r64m2w/Screen%20Shot%202016-05-19%20at%209.18.39%20AM.png?raw=1)

Shotn is a url shortening application.
The application accepts a long url and returns a shorter url that's much easier to remember.
Alternatively, you can provide a custom string that will be used in the url.

    E.g http://stackoverflow.com/questions/1722749/how-to-use-rspecs-should-raise-with-any-kind-of-exception/1722839#1722839
    becomes:
    http://shotnr.com/L

You can access the live version on http://shotnr.com

## Application Features

  1. Shortens a long url to a much shorter one and easier to remember
  2. Can accept a vanity string to provide a customised url
  3. User is able to edit the customised url and change the details.
  4. User can disable and enable shotlinks at will
  5. Gives statistics on how many times the shotlink has been used
  6. Shows the top users on the application based on their total clicks
  7. Shows the recent and popular shotlinks

## Getting Started

  1. `git clone https://github.com/andela-akabiru/shotnr.git`
  2. `cd shotnr`
  3. `bundle install`
  4. `rake db:setup`
  5. `rails serve`

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisities

  1. [Ruby](https://github.com/rbenv/rbenv)
  2. [PostgreSQL](http://www.postgresql.org/download/macosx/)
  3. [Bundler](http://bundler.io/)
  4. [Rails](http://guides.rubyonrails.org/getting_started.html#installing-rails)
  5. [RSpec](http://rspec.info/)

## Running the tests
    1. cd shotnr
    2. bundle exec rake


## Built With

  1. [Ruby on Rails](https://github.com/rails/rails)
  2. [Bootstrap 4](https://github.com/twbs/bootstrap/tree/v4-dev)

## Application Limitations

  1. The application only accepts a custom string of length > 5 characters

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://opensource.org/licenses/MIT) file for details
