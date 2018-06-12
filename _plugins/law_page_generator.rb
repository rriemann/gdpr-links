# coding: utf-8
# Generate pages from individual records in yml files
# (c) 2018 Robert Riemann
# (c) 2014-2016 Adolfo Villafiorita
# Distributed under the conditions of the MIT License

module Jekyll

  module Sanitizer
    # strip characters and whitespace to create valid filenames, also lowercase
    def sanitize_filename(name)
      if(name.is_a? Integer)
        return name.to_s
      end
      return name.tr(
  "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÑñÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
  "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz"
).downcase.strip.gsub(' ', '-').gsub(/[^\w.-]/, '')
    end
  end

  # this class is used to tell Jekyll to generate a page
  class LawPage < Page
    include Sanitizer

    # - site and base are copied from other plugins: to be honest, I am not sure what they do
    #
    # - `index_files` specifies if we want to generate named folders (true) or not (false)
    # - `dir` is the default output directory
    # - `data` is the data defined in `_data.yml` of the record for which we are generating a page
    # - `name` is the key in `data` which determines the output filename
    # - `template` is the name of the template for generating the page
    # - `extension` is the extension for the generated file
    def initialize(site, base, index_files, dir, category, data, name, template, extension)
      @site = site
      @base = base

      # @dir is the directory where we want to output the page
      # @name is the name of the page to generate
      #
      # the value of these variables changes according to whether we
      # want to generate named folders or not
      filename = sanitize_filename(category).to_s + "/" +
                 sanitize_filename(data[name]).to_s
      @dir = dir + (index_files ? "/" + filename + "/" : "")
      @name = (index_files ? "index" : filename) + "." + extension.to_s

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), template + ".html")
      self.data['title'] = data[name]
      self.data['category'] = category
      # add all the information defined in _data for the current record to the
      # current page (so that we can access it with liquid tags)
      self.data.merge!(data)
    end
  end

  class LawPageGenerator < Generator
    safe true

    def generate(site)
      site.data['gdpr']['chapters'].each do |chapter|
        category = chapter['title']
        chapter['contents'].each do |article|
          site.pages << LawPage.new(site, site.source, true, "gdpr", category, article, "title", "law", "html")
        end
      end
    end
  end
end
