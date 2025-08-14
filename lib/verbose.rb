# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'time'
require 'tago'

# Decorator that logs method calls to any object, providing transparency
# into the execution flow by recording method names, parameters, and execution time.
# This class wraps any Ruby object and intercepts method calls, logging each
# invocation with its arguments and the time taken to execute.
#
# The decorator uses method_missing to intercept all method calls on the wrapped
# object, logs them with parameter details, and then delegates to the original
# object. String parameters are truncated for readability, complex objects are
# shown as their class names, and primitive values are displayed as-is.
#
# @example Basic usage with standard output
#   repository = Verbose.new(Repository.new)
#   repository.fetch('main')
#   # Output: Repository.fetch("main") in 23ms
#
# @example Using with a custom logger
#   require 'logger'
#   logger = Logger.new('app.log')
#   service = Verbose.new(Service.new, log: logger)
#   service.process(data: { id: 42 })
#   # Logs to app.log: Service.process(Hash) in 150ms
#
# @example Wrapping objects with blocks
#   file = Verbose.new(File)
#   file.open('data.txt', 'r') do |f|
#     f.read
#   end
#   # Output: File.open("data.txt", "r") in 5ms
#
# @example Parameter truncation for long strings
#   parser = Verbose.new(Parser.new)
#   parser.parse('very long text that exceeds maximum display length...')
#   # Output: Parser.parse("very long t...lay length...") in 10ms
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
      super(mtd, *args)
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
