
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

      # Rubygems API does not have a way to ask for detailed information about
      # a particular version of a gem so you have to grab the latest.

      # Generate a Rubygem, a helper class that grants us access to the RubyGems
      # API to query for information related to the Gem

      ruby_gem = RubyGem.new(gem_name)

      # The gem specification information from Rubygems contains several fields
      # that I should provide support for within the Dependency class simply by
      # loading the gem specification value information into the dependency.

      dependency.gemspec = ruby_gem.gemspec
      dependency.versions = ruby_gem.versions

    end

    #
    # Default YARD Parser methods that are not needed for processing.
    #
    def tokenize ; end

    #
    # Default YARD Parser methods that are not needed for processing.
    #
    def enumerator ; end

  end

  YARD::Parser::SourceParser.register_parser_type :lockfile, LockfileParser, 'lock'
end