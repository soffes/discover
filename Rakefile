require 'bundler/gem_tasks'

desc 'Load an IRB session with Discover loaded'
task :console do
  $:.unshift(File.expand_path('../lib', __FILE__))
  require 'discover'
  require 'irb'
  ARGV.clear
  IRB.start
end
