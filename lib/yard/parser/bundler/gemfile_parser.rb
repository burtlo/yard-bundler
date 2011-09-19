
module YARD::Parser::Bundler
  
  class GemfileParser < YARD::Parser::Base
    
    def initialize(source, file = '(stdin)')
      log.info "GemfileParser#initialize #{file}"
      @source = source
      @file = file
    end
    
    #
    # Parser the output of Rspec documentation output.
    # 
    def parse
      
      # TODO: Because the Gemfile parser will look at any file without a suffix
      # it is important to make sure that the filename is actually Gemfile
      
      gemfile = File.basename(@file)
      
      log.info "Gemfile - Bundler: #{gemfile}"
      
      # TODO: Find the lock file that may be associated with the Gemfile
      
      # Use Bundler's DSL evaluator to generate the domain objects
      # bundle = Bundler::Dsl.new
      # bundle.instance_eval(@source, @file, 1)
      
      lock = Bundler::LockfileParser.new(@source)
      
      lock

      # Bundler::Dsl does grant access to the instance variables so we will 
      # add attribute readers to allow us to read the following attributes.

      # class << bundle
      #   attr_reader :rubygems_source, :sources, :dependencies, :groups, :platforms
      # end
      
      # DEBUG
      
      # Dependencies - contains the entries in the Gemfile with their specified
      # versions.

      #log.info bundle.dependencies
      
      # Specs - contains the entries in the Gemfile.lock with the specific versions.
      
      #log.info bundle.specs
      
      # For all the specs, we want to capture the project information and
      # add it to the the dependency
      
      # bundle.specs.each do |spec|
      #   decompose spec
      # end
      
      # Graph Viz - Grab the visualization data that can be generated from Bundler
      # and include that functionality into the output.
      #graph = Bundler::Graph.new(bundle)
      
      # Save the graph of the bundler dependencies to the doc directory
      # 
      # @note that this doc directory is being hard-coded and YARD likely has
      #   an option to find the output directory
      # 
      #graph.viz("#{working_directory}/doc/gemfile.png")
      
    end
    
    #
    # @param [Gem::Specification] gem_specification containing the name and the
    #   version of the gem specification.
    #
    def decompose(gem_specification)
      
      gem_name = gem_specification.name
      gem_version = gem_specification.version.to_s
      
      dependency = YARD::CodeObjects::Bundler::Dependency.new(YARD::CodeObjects::Bundler::BUNDLER_NAMESPACE,gem_name)
      dependency.version = gem_version
      
      gemspec_mash = nil
      versions_mash = nil
      
      # Rubygems API does not have a way to ask for detailed information about
      # a particular version of a gem so you have to grab the latest.

      # Generate a Rubygem, a helper class that grants us access to the RubyGems
      # API to query for information related to the Gem

      ruby_gem = RubyGem.new(gem_name)
      
      gemspec_mash = ruby_gem.gemspec
      versions_mash = ruby_gem.versions
      
      # project_uri
      # - when github has been specified, retrieve additional information
      
      # TODO: check for github gem being installed
      
      if gemspec_mash and user_repo = gemspec_mash.source_code_uri.to_s[/^http:\/\/github.com\/(.+)/,1]
        
        log.debug "Setting Project URL: #{gemspec_mash.source_code_uri}"
        dependency.project_url = gemspec_mash.source_code_uri
        
        log.debug "Loading Github Repo: #{user_repo}"
        github_repo = Octokit.repo(user_repo)
        
        log.debug "Setting Github Issues: #{user_repo}"
        # Retrieve the issues
        dependency.issues = Octokit.issues(user_repo) if github_repo.has_issues
        
        log.debug "Setting Github Commits: #{user_repo}"
        # Retrieve the last commits
        dependency.commits = Octokit.commits(user_repo)
        
      end
      
      dependency.versions = versions_mash
      
      # stackoverflow - last few tagged topics that match the gem
      # TODO: change to use search text and perhaps not just tags
      # StackExchange::StackOverflow::Question.find_by_tags gem_name
      # 
      
    end
    
    
    
    #
    # Default YARD Parser methods
    # 
    def tokenize
      
    end
    
    #
    # Default YARD Parser methods
    # 
    def enumerator
      
    end
    
  end
  
  # YARD::Parser::SourceParser.register_parser_type :gemfile, GemfileParser, ''
end