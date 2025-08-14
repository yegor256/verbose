# A Decorator that Logs Every Method Call of a Decoratee

[![DevOps By Rultor.com](https://www.rultor.com/b/yegor256/verbose)](https://www.rultor.com/p/yegor256/verbose)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/verbose/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/verbose/actions/workflows/rake.yml)
[![PDD status](https://www.0pdd.com/svg?name=yegor256/verbose)](https://www.0pdd.com/p?name=yegor256/verbose)
[![Gem Version](https://badge.fury.io/rb/verbose.svg)](https://badge.fury.io/rb/verbose)
[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/verbose.svg)](https://codecov.io/github/yegor256/verbose?branch=master)
[![Yard Docs](https://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/github/yegor256/verbose/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/verbose)](https://hitsofcode.com/view/github/yegor256/verbose)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/verbose/blob/master/LICENSE.txt)

Here is how you use it:

```ruby
require 'verbose'
x = MyObject.new
v = Verbose.new(x)
v.foo # see the logging line in the console
```

Instead of printing to the console, you can pass an instance
of the [Logger][logger] class to the `Verbose` constructor:

```ruby
require 'verbose'
require 'logger'
x = MyObject.new
v = Verbose.new(x, log: Logger.new(STDOUT))
v.foo
```

I also recommend checking the
[`loog`](https://github.com/yegor256/loog) gem
for more object-oriented logging.

## How to contribute

Read
[these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure your build is green before you contribute
your pull request. You will need to have
[Ruby](https://www.ruby-lang.org/en/) 3.2+ and
[Bundler](https://bundler.io/) installed. Then:

```bash
bundle update
bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.

[logger]: https://ruby-doc.org/stdlib-2.7.0/libdoc/logger/rdoc/Logger.html
