module BundlerInTheYARD
  VERSION = '0.0.1' unless defined?(BundlerInTheYARD::VERSION)
end

require File.dirname(__FILE__) + "/yard/parser/bundler/gemfile_parser"
require File.dirname(__FILE__) + "/yard/code_objects/bundler/gemfile"

if RUBY19
  require File.dirname(__FILE__) + "/yard/handlers/gemfile"
  require File.dirname(__FILE__) + "/yard/code_objects/bundler/gemfile"
  require File.dirname(__FILE__) + "/yard/code_objects/bundler/dependency"
end

# This registered template works for yardoc
YARD::Templates::Engine.register_template_path File.dirname(__FILE__) + '/templates'

# The following static paths and templates are for yard server
#YARD::Server.register_static_path File.dirname(__FILE__) + "/templates/default/fulldoc/html"
#YARD::Server.register_static_path File.dirname(__FILE__) + "/docserver/default/fulldoc/html"