
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
      
      # Use Bundler's DSL evaluator to generate the domain objects
      bundle = Bundler::Dsl.new
      bundle.instance_eval(@source, @file, 1)
      
      # Bundler::Dsl does grant access to the instance variables so we will 
      # add attribute readers to allow us to read the following attributes.

      class << bundle
        attr_reader :rubygems_source, :sources, :dependencies, :groups, :platforms
      end
      
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