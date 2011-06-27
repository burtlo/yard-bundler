require 'YARD'
require File.dirname(__FILE__) + "/lib/yard-bundler"

module BundlerInTheYARD
  extend self
  
  def show_version_changes(version)
    date = ""
    changes = []  
    grab_changes = false

    File.open("#{File.dirname(__FILE__)}/History.txt",'r') do |file|
      while (line = file.gets) do

        if line =~ /^===\s*#{version.gsub('.','\.')}\s*\/\s*(.+)\s*$/
          grab_changes = true
          date = $1.strip
        elsif line =~ /^===\s*.+$/
          grab_changes = false
        elsif grab_changes
          changes = changes << line
        end

      end
    end

    { :date => date, :changes => changes }
  end
end

Gem::Specification.new do |s|
  s.name        = 'yard-bundler'
  s.version     = ::BundlerInTheYARD::VERSION
  s.authors     = ["Franklin Webber"]
  s.description = %{ 
    YARD-Bundler is a YARD extension that processes Bundler Gemfiles. }
  s.summary     = "Bundler in YARD"
  s.email       = 'franklin.webber@gmail.com'
  s.homepage    = "http://github.com/burtlo/yard-bundler"

  s.platform    = Gem::Platform::RUBY
  
  changes = BundlerInTheYARD.show_version_changes(::RSpecInTheYARD::VERSION)
  
  s.post_install_message = %{
(##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##)

  Thank you for installing yard-bundler #{::BundlerInTheYARD::VERSION} / #{changes[:date]}.
  
  Changes:
  #{changes[:changes].collect{|change| "  #{change}"}.join("")}
(##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##) (##)

}

  s.add_dependency 'yard', '~> 0.7'
  s.add_dependency 'bundler', '~> 1.0'
  s.add_dependency 'octokit', '~> 0.6'
  s.add_dependency 'hashie', '~> 1.0'
  
  s.rubygems_version   = "1.3.7"
  s.files            = `git ls-files`.split("\n")
  s.extra_rdoc_files = ["README.md", "History.txt"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
