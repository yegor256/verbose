# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'time'
require 'tago'

# Decorator.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class Verbose
  def initialize(origin, log: nil)
    @origin = origin
    @log = log
  end

  def method_missing(*args)
    start = Time.now
    mtd = args.shift
    if @origin.respond_to?(mtd)
      params = @origin.method(mtd).parameters
      reqs = params.count { |p| p[0] == :req }
      if params.any? { |p| p[0] == :key } && args.size > reqs
        @origin.__send__(mtd, *args[0...-1], **args.last) do |*a|
          yield(*a) if block_given?
        end
      else
        @origin.__send__(mtd, *args) do |*a|
          yield(*a) if block_given?
        end
      end
    else
      super
    end
  ensure
    params = args.map do |a|
      if a.is_a?(String)
        max = 32
        a = a.inspect
        if a.length > max
          "#{a[0..((max / 2) - 2)]}...#{a[((max / 2) + 1)..]}"
        else
          a
        end
      elsif [Integer, Float, TrueClass, FalseClass].include?(a.class)
        a
      else
        a.class
      end
    end
    msg = "#{@origin.class}.#{mtd}(#{params.join(', ')}) in #{start.ago}"
    if @log.respond_to?(:debug)
      @log.debug(msg)
    else
      puts(msg)
    end
  end

  def respond_to?(method, include_private = false)
    @origin.respond_to?(method, include_private)
  end

  def respond_to_missing?(_method, _include_private = false)
    true
  end
end
