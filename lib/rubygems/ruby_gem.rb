module YARD::Parser::Bundler

  #
  # A Rubygem is a wrapper for RubyGems.org API.
  # 
  # @see http://guides.rubygems.org/rubygems-org-api/
  # 
  class RubyGem

    attr_reader :name

    #
    # Generate a new Rubygem
    # 
    # @param [String] gem_name the name of the gem
    #
    def initialize(gem_name)
      @name = gem_name
    end

    #
    # Return the gemspec for the specified gem name
    # 
    # @see http://guides.rubygems.org/rubygems-org-api/#gem
    # 
    # @return [Hashie::Mash] a Hashie::Mash of the gem
    # 
    # @example Ask Rubygems for the gemspec
    # 
    #     curl http://rubygems.org/api/v1/gems/rails.json
    # 
    def gemspec

      open "http://rubygems.org/api/v1/gems/#{@name}.json" do |response|
        json = JSON.parse(response.read)
        gemspec_mash = Hashie::Mash.new json
      end
      
    rescue => exception
      log.error "could not load the rubygems information for #{@name} => #{exception}"
    end

    #
    # Return the version information for the specified gem name
    # 
    # @see http://guides.rubygems.org/rubygems-org-api/#gemversion
    # 
    # @return [Hashie::Mash] a Hashie::Mash of the gem
    # 
    # @example Ask Rubygems for the versions
    # 
    #     curl https://rubygems.org/api/v1/versions/coulda.json
    # 
    def versions
    
      open "http://rubygems.org/api/v1/versions/#{@name}.json" do |response|
        json = JSON.parse(response.read)
        versions_mash = json.map {|version| Hashie::Mash.new version }
      end
      
    rescue => exception
      log.error "could not load the rubygems information for #{@name} => #{exception}"
    end

  
  end
  
end