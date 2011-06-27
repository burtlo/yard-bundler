
module YARD::CodeObjects
  module Bundler
    
    #
    # Generate a dependency object that we can represent in t
    # 
    class Dependency < YARD::CodeObjects::Base
      
      attr_accessor :version
      
      attr_accessor :documentation_url
      
      attr_accessor :project_url
      
      def rubygems_version_url
        "http://rubygems.org/gems/#{name}/versions/#{version}"
      end
      
      attr_accessor :issues, :commits
      
      def open_bugs
        issues.find_all {|issue| issue.state == "open" and issue.labels.include?("bug") }
      end
      
      # TODO: open bugs against the current version
      
    end
    
  end
end