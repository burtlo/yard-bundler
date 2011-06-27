def init
  super
end

# Append yard-bundler stylesheet to yard core stylesheets
def stylesheets
  log.info "Loading the yard-bundler stylesheets"
  super + %w(css/bundler.css)
end