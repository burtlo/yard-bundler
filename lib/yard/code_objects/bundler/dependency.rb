
module YARD::CodeObjects
  module Bundler
    
    #
    # Generate a dependency object that we can represent in t
    # 
    class Dependency < YARD::CodeObjects::Base
      
      attr_accessor :version
      
      #
      # All the versions found on Rubygems for the gem
      # 
      attr_accessor :versions
      
      #
      # @return [Integer] the number of newer versions than this dependency
      # 
      def newer_versions
        versions.index(versions.find {|a_version| a_version.number == version})
      end
      
      # 
      # For the dependency generate the link to the documentation.
      # @return [String] url to the docs on Rubydoc
      def documentation_url
        "http://rubydoc.info/gems/#{name}/#{version}/frames"
      end
      
      # If the project has 'source_code_uri' specified
      attr_accessor :project_url
      
      #
      # For projects generate the Rubygems URL based on the gem name and the
      # gem version.
      # 
      # @return [String] url to the Rubygems page about the gem version
      def rubygems_version_url
        "http://rubygems.org/gems/#{name}/versions/#{version}"
      end
      
      #
      # Github projects have their issues captured
      # 
      attr_accessor :issues
      
      # For projects with GitHub issues filter them to just the open bugs
      # as we are not interested in feature requests and other information that
      # may be captured in the issues response.
      def open_bugs
        issues.find_all {|issue| issue.state == "open" and issue.labels.include?("bug") }
      end
      
      # Return open bugs against the current version - requires the project to
      # use good tagging or for other fields to capture details about the gem
      # version. That or the description will need to be parsed to find out if
      # the open bugs apply.
      
      
      #
      # Github projects have their comments captured
      # 
      attr_accessor :commits
      
      def commits
        @commits ||= []
      end
      
      def last_commit_date
        commits.first.committed_date
      end
      
    end
    
  end
end