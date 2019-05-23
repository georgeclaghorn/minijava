task default: %w[ lib/minijava/parser.rb ]

file "lib/minijava/parser.rb" => "lib/minijava/parser.racc" do
  sh "bundle exec racc lib/minijava/parser.racc -o lib/minijava/parser.rb"
end
