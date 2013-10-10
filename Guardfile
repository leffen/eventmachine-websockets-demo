
guard 'rspec', :all_after_pass => false, :halt_on_fail =>true, :cli => "--color --format d" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/ewd/(.+)\.rb$})     { |m| "spec/lib/ewd/#{m[1]}_spec.rb" }

  watch("app.rb") { "spec" }
end

guard 'bundler' do
  watch('Gemfile')
end


