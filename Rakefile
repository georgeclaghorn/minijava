require "rake/testtask"

task default: :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = false
end

task "parser:generate": "lib/minijava/parser.rb"

file "lib/minijava/parser.rb" => "lib/minijava/parser.racc" do
  sh "bundle exec racc lib/minijava/parser.racc -o lib/minijava/parser.rb -v -g"
end
