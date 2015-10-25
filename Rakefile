require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs.push 'test'
  t.pattern = 'test/**/*_test.rb'
  t.warning = false
  t.verbose = true
end

task default: [:test]
