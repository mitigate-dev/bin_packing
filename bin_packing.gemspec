require File.expand_path('../lib/bin_packing/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'bin_packing'
  s.version = BinPacking::VERSION
  s.date = '2016-01-22'
  s.summary = '2D bin packing algorithm'
  s.description = <<-TXT
Provides algorithm for placing rectangles (box-es) in one or multiple rectangular areas (bins) with reasonable allocation efficiency.
TXT
  s.authors = ['MAK IT']
  s.email = 'info@makit.lv'
  s.files = Dir['lib/**/*.rb'] + Dir['lib/bin_packing/resources/*']
  s.homepage = 'http://rubygems.org/gems/bin_packing'
  s.license = 'MIT'
  s.add_development_dependency 'rspec', '~> 3.0', '>= 3.0.0'
end
