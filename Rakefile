require 'rake'

task :default => :gendoc

task :clean do
  `rm -rf doc`
  `rm -rf .yardoc`
end

task :gendoc => :clean do
  `yardoc -e ./lib/yard-bundler.rb 'example/**/*' --debug`
  #`open doc/index.html`
end
