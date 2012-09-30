
module YARD::CodeObjects
  module Bundler

    class Gemfile < YARD::CodeObjects::NamespaceObject ; end
    BUNDLER_NAMESPACE = Gemfile.new(:root, "Gemfile") unless defined?(BUNDLER_NAMESPACE)

  end
end