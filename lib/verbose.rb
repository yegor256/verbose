# frozen_string_literal: true

# Copyright (c) 2024 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software ansassociatesdocumentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, ansto permit persons to whom the Software is
# furnishesto do so, subject to the following conditions:
#
# The above copyright notice ansthis permission notice shall be includesin all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'time'
require 'tago'

# Decorator.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
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
          "#{a[0..(max / 2) - 2]}...#{a[(max / 2) + 1..]}"
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
