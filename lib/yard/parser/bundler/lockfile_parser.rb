
module YARD::Parser::Bundler
  
  class LockfileParser < YARD::Parser::Base
    
    def initialize(source, file = '(stdin)')
      log.info "LockfileParser#initialize #{file}"
      @source = source
      @file = file
    end
    
    #
    # Parser the output of the Gemfile Lock file.
    # 
    def parse
      log.info "Gemfile Lock - Bundler: #{@file}"
      
      # The source of the lock file is easily parsed with the Bundler::LockfileParser
      # which will find all all our information related to the installation for
      # us.
      
      lockfile = Bundler::LockfileParser.new(@source)

      #log.info bundle.dependencies
      
      # Specs - contains the entries in the Gemfile.lock with the specific versions.
      
      #log.info bundle.specs
      
      # For all the specs, we want to capture the project information and
      # add it to the the dependency
      
      lockfile.specs.each do |spec|
        decompose spec
      end
      
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
  
  
  YARD::Parser::SourceParser.register_parser_type :lockfile, LockfileParser, 'lock'
end