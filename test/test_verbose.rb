# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'loog'
require_relative '../lib/verbose'

# Main test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
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
    assert_includes(log.to_s, '(42) in', log)
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

  def test_raises_on_undefined_method
    obj = Object.new
    def obj.existing_method
      42
    end
    log = Loog::Buffer.new
    v = Verbose.new(obj, log:)
    assert_equal(42, v.existing_method)
    error = assert_raises(NoMethodError) do
      v.nonexistent_method('some', 'args')
    end
    assert_match(/undefined method/, error.message)
  end
end
