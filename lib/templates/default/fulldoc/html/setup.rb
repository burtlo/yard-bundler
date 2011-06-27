def init
  
  # The Bundler namespace was stored within the Registry attached as a child on
  # root, however, we do not want to have it displayed in the Class List so we 
  # have it removed.
  YARD::Registry.root.children.delete YARD::CodeObjects::Bundler::BUNDLER_NAMESPACE
  
  # Generate an ExtraFileObject, this is similar to a README, out of the Gemfile
  gemfile = YARD::CodeObjects::ExtraFileObject.new("Gemfile.html",erb(:gemfile))
  
  # Add it to the files that should be persisted and appearing in the FileList
  options[:files] << gemfile
  
  super
  
  asset("css/bundler.css",file("css/bundler.css",true))
end


#
# Helper method for providing the gemfile dependencies for use in the gemfile
# template (gemfile.erb).
# 
def dependencies
  @dependencies ||= begin
    YARD::Registry.all(:dependency)
  end
end
