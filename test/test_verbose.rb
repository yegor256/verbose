# frozen_string_literal: true

# Copyright (c) 2024 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'minitest/autorun'
require 'loog'
require_relative '../lib/verbose'

# Main test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
class TestVerbose < Minitest::Test
  def test_simple
    obj = Object.new
    def obj.read(foo)
      foo
    end
    log = Loog::Buffer.new
    obj = Verbose.new(obj, log:)
    assert_equal(42, obj.read(42))
    assert_equal(42, obj.read(42))
    assert(log.to_s.include?('finished in'), log)
  end

  def test_simple_to_stdout
    obj = Object.new
    def obj.read(foo)
      foo
    end
    obj = Verbose.new(obj)
    assert_equal(42, obj.read(42))
  end

  def test_works_with_optional_arguments
    obj = Object.new
    def obj.foo(first, _second, ext1: 'a', ext2: 'b')
      first + ext1 + ext2
    end
    log = Loog::Buffer.new
    v = Verbose.new(obj, log:)
    assert_equal('.xy', v.foo('.', {}, ext1: 'x', ext2: 'y'))
    assert_equal('fzb', v.foo('f', {}, ext1: 'z'))
    assert_equal('-ab', v.foo('-', {}))
  end

  def test_works_with_default_value
    obj = Object.new
    def obj.foo(first, second = 42)
      first + second
    end
    log = Loog::Buffer.new
    v = Verbose.new(obj, log:)
    assert_equal(15, v.foo(7, 8))
    assert_equal(43, v.foo(1))
  end
end
