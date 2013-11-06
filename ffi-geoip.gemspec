# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "ffi-geoip"
  s.version     = "0.0.1"
  s.authors     = ["lian"]
  s.email       = ["meta.rb@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{ffi-geoip}
  s.description = %q{ffi-geoip}
  s.homepage    = "https://github.com/lian/ffi-geoip"

  s.rubyforge_project = "ffi-geoip"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_rubygems_version = ">= 1.3.6"
  #s.add_development_dependency "bacon"

  #s.add_development_dependency "bacon"
end
