# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'loog'
require 'minitest/autorun'
require_relative '../lib/verbose'

# Main test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class TestVerbose < Minitest::Test
  def test_simple
    obj = Object.new
    def obj.read(foo)
      foo
    end
    log = Loog::Buffer.new
    v = Verbose.new(obj, log:)
    assert_equal(42, v.read(42))
    assert_equal(42, v.read(42))
    assert_includes(log.to_s, '(42) in', log)
  end

  def test_preserves_absent_block
    obj = Object.new
    def obj.read(prefix = '', suffix: '')
      [prefix, suffix, block_given?]
    end
    v = Verbose.new(obj, log: Loog::Buffer.new)
    assert_equal(['', '', false], v.read)
    assert_equal(['a', 'b', false], v.read('a', suffix: 'b'))
  end

  def test_forwards_supplied_block
    obj = Object.new
    def obj.read(prefix = '', suffix: '')
      yield(prefix + suffix)
    end
    v = Verbose.new(obj, log: Loog::Buffer.new)
    assert_equal('x!', v.read { |value| "#{value}x!" })
    assert_equal('ab!', v.read('a', suffix: 'b') { |value| "#{value}!" })
  end

  def test_truncates_long_string_arguments
    obj = Object.new
    def obj.read(value)
      value
    end
    log = Loog::Buffer.new
    value = 'a' * 1000
    assert_equal(value, Verbose.new(obj, log:).read(value))
    argument = log.to_s[/read\((.*)\) in/, 1]
    assert_equal(32, argument.length)
    assert_equal("#{value.inspect[0, 15]}...#{value.inspect[-14, 14]}", argument)
  end

  def test_simple_to_stdout
    obj = Object.new
    def obj.read(foo)
      foo
    end
    assert_equal(42, Verbose.new(obj).read(42))
  end

  def test_works_with_optional_arguments
    obj = Object.new
    def obj.foo(first, _second, ext1: 'a', ext2: 'b')
      first + ext1 + ext2
    end
    v = Verbose.new(obj, log: Loog::Buffer.new)
    assert_equal('.xy', v.foo('.', {}, ext1: 'x', ext2: 'y'))
    assert_equal('fzb', v.foo('f', {}, ext1: 'z'))
    assert_equal('-ab', v.foo('-', {}))
  end

  def test_works_with_default_value
    obj = Object.new
    def obj.foo(first, second = 42)
      first + second
    end
    v = Verbose.new(obj, log: Loog::Buffer.new)
    assert_equal(15, v.foo(7, 8))
    assert_equal(43, v.foo(1))
  end

  def test_raises_on_undefined_method
    obj = Object.new
    def obj.fetch
      42
    end
    v = Verbose.new(obj, log: Loog::Buffer.new)
    assert_equal(42, v.fetch)
    assert_raises(NoMethodError) { v.nonexistent_method('some', 'args') }
  end
end
