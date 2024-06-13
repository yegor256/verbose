# A Decorator that Logs Every Method Call of a Decoratee

[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/verbose)](http://www.rultor.com/p/yegor256/verbose)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/verbose/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/verbose/actions/workflows/rake.yml)
[![PDD status](http://www.0pdd.com/svg?name=yegor256/verbose)](http://www.0pdd.com/p?name=yegor256/verbose)
[![Gem Version](https://badge.fury.io/rb/verbose.svg)](http://badge.fury.io/rb/verbose)
[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/verbose.svg)](https://codecov.io/github/yegor256/verbose?branch=master)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/yegor256/verbose/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/verbose)](https://hitsofcode.com/view/github/yegor256/verbose)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/verbose/blob/master/LICENSE.txt)

Here is how you use it:

```ruby
require 'verbose'
x = MyObject.new
v = Verbose.new(x)
v.foo() # see the logging line in the console
```

You can pass an instance of a [Logger][logger] to it too:

```ruby
require 'verbose'
require 'logger'
x = MyObject.new
v = Verbose.new(x, log: Logger.new(STDOUT))
v.foo()
```

I also recommend you to check the
[`loog`](https://github.com/yegor256/loog) gem,
for more object-oriented logging.

## How to contribute

Read
[these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure you build is green before you contribute
your pull request. You will need to have
[Ruby](https://www.ruby-lang.org/en/) 3.2+ and
[Bundler](https://bundler.io/) installed. Then:

```bash
bundle update
bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.

[logger]: https://ruby-doc.org/stdlib-2.7.0/libdoc/logger/rdoc/Logger.html
