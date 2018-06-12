require 'yaml'

module Jekyll
  module RenderArticleFilter
    def render_article(element)
      return case element.type
      when 'chapter'
      when 'article'
        <<-HTML
          <div class="article">
            Number: #{element.number}

            <ol>
              #{render_article(element.contents)}
            </ol>
          </div>
        HTML
      when 'text'
        <<-HTML
          <li>
            #{element.subpoints.each{|sp| render_article(sp)}}
          </li>
        HTML
      when 'point'
      when 'subpoint'
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::RenderArticleFilter)
