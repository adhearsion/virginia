# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "virginia/version"

Gem::Specification.new do |s|
  s.name        = "virginia"
  s.version     = Virginia::VERSION
  s.authors     = ["Luca Pradovera"]
  s.email       = ["lpradovera@mojolingo.com"]
  s.homepage    = ""
  s.summary     = %q{A Reel interface to Adhearsion}
  s.description = %q{Gives an Adhearsion app the ability to be controlled and interact over HTTP}

  s.rubyforge_project = "virginia"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency %q<adhearsion>, ["~> 2.4"]
  s.add_runtime_dependency %q<activesupport>, [">= 3.0"]
  s.add_runtime_dependency %q<reel>, ["~> 0.5.0"]
  s.add_runtime_dependency %q<reel-rack>

  s.add_development_dependency %q<bundler>, ["~> 1.0"]
  s.add_development_dependency %q<rspec>, ["~> 2.5"]
  s.add_development_dependency %q<rake>, [">= 0"]
  s.add_development_dependency %q<timecop>
  s.add_development_dependency %q<guard-rspec>
 end
