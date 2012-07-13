# AutoQwert

AutoQwert is a Ruby script you can run as a cron job to automatically receive
emails whenever there is a new [Qwertee](http://qwertee.com) t-shirt.

It's stupidly simple.

## Requirements

1. Ruby 1.9.2 (because I'm lazy)
2. Bundler
3. A sendmail, or localhost SMTP (configure Pony yourself if you want).

## Installing

1. Clone the repository (or download it).
2. Run `bundle`.
3. Edit `config.yml`.
4. Run with `bundle exec ruby auto-qwert.rb`. You could set this up as a cron
   job.
