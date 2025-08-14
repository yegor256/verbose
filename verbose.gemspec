# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'English'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=3.0'
  s.name = 'verbose'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'A Decorator that Logs Every Method Call of a Decoratee'
  s.description =
    'Simplifies the process of tracking method calls in a particular object, ' \
    'usually when it is a slow-moving object'
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'https://github.com/yegor256/verbose.rb'
  s.files = `git ls-files`.split($RS)
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  s.add_dependency 'loog', '~>0.2'
  s.add_dependency 'tago', '~>0.0'
  s.metadata['rubygems_mfa_required'] = 'true'
end
