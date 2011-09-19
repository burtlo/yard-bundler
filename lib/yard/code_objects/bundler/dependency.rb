
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
      # @return [Array<String>] a list of the versions newer than this current
      #   version.
      # 
      def newer_versions
        @newer_versions ||= begin
          current_version_index = versions.index(versions.find {|a_version| a_version.number == version})
          versions[0..current_version_index] - [versions[current_version_index]]
        end
      end
      
      attr_accessor :gemspec
      
      # {
      #   "name": "rails",
      #   "info": "Rails is a framework for building web-application using CGI, FCGI, mod_ruby,
      #            or WEBrick on top of either MySQL, PostgreSQL, SQLite, DB2, SQL Server, or
      #            Oracle with eRuby- or Builder-based templates.",
      #   "version": "2.3.5",
      #   "version_downloads": 2451,
      #   "authors": "David Heinemeier Hansson",
      #   "downloads": 134451,
      #   "project_uri": "http://rubygems.org/gems/rails",
      #   "gem_uri": "http://rubygems.org/gems/rails-2.3.5.gem",
      #   "homepage_uri": "http://www.rubyonrails.org/",
      #   "wiki_uri": "http://wiki.rubyonrails.org/",
      #   "documentation_uri": "http://api.rubyonrails.org/",
      #   "mailing_list_uri": "http://groups.google.com/group/rubyonrails-talk",
      #   "source_code_uri": "http://github.com/rails/rails",
      #   "bug_tracker_uri": "http://rails.lighthouseapp.com/projects/8994-ruby-on-rails",
      #   "dependencies": {
      #     "runtime": [
      #       {
      #         "name": "activesupport",
      #         "requirements": ">= 2.3.5"
      #       }
      #     ],
      #     "development": [ ]
      #   }
      # }
      
      # Create within the dependency all of the possible links if the value has
      # 
      [ :project, :gem, :homepage, :wiki, :documentation, :mailing_list, :source_code, :bug_tracker ].each do |property|
        
        define_method("#{property}_url") do
          gemspec["#{property}_uri"] if gemspec and gemspec["#{property}_uri"] and gemspec["#{property}_uri"] != ""
        end
        
      end

      # 
      # For the dependency generate the link to the documentation.
      # @return [String] url to the docs on Rubydoc
      def yardoc_url
        "http://rubydoc.info/gems/#{name}/#{version}/frames"
      end
      
      #
      # For projects generate the Rubygems URL based on the gem name and the
      # gem version.
      # 
      # @return [String] url to the Rubygems page about the gem version
      def rubygems_version_url
        "http://rubygems.org/gems/#{name}/versions/#{version}"
      end
      
      def dependencies
        @dependencies ||= begin

          if gemspec and gemspec["dependencies"] and gemspec["dependencies"]["runtime"]
            
            
            gemspec["dependencies"]["runtime"].map do |gemspec_dependency|
              
              # Find the dependency within the the Dependency Registry
              YARD::Registry.all(:dependency).find {|dep| dep.name == gemspec_dependency["name"].to_sym }
              
            end.compact

          end
          
        end
        
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