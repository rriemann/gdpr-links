require 'yaml'

module Jekyll
  module YAMLFilter
    def yaml(object)
      object.to_yaml
    end
  end
end

Liquid::Template.register_filter(Jekyll::YAMLFilter)
