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

#
# Ideally this would perform the rails actionpack date helper, but in the interest
# of keeping this small, this is simply going to return the date of the event
#
# @param [String] date_string representation to convert to something more human
#   readable.
# @return [String] a time that is human friendly
#
def human_friendly_time(time_string)
  # if the time is within the last two days, from now, specify the time in hours
  # ago, otherwise present the information as as a date string

  # require 'active_support/time'
  # two_days_ago = DateTime.current.advance :days => -2
  #
  # if DateTime.parse(time_string) - two_days_ago > 0
  #   DateTime.parse(time_string) - two_days_ago
  # end

  time_string

rescue
  log.debug "Failed to generate a human friendly time from #{time_string}"
  time_string
end


def gravatar_image_from_id(hash)
  "http://www.gravatar.com/avatar/#{hash}?s=25"
end