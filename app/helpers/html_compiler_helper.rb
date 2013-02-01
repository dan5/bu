module HtmlCompilerHelper
  def html_compiler(str)
    if str =~ /\A__hikidoc__/
      str.sub!(/\A__hikidoc__\s*/, '')
      hikidoc_to_html(str)
    else
      simple_html_compiler(str)
    end
  end

  def comment_html_compiler(str)
    url2link_of_string h(str)
  end

  def simple_html_compiler(str)
    url2link_of_string h(str).gsub("\n", '<br />')
  end

  def url2link_of_string(html_string,options={})
    target = options[:target] || '_blank'
    URI.extract(html_string).uniq.each{|url|
      html_string.gsub!(url,"<a href='#{url}' target='#{target}'>#{url}</a>")
    }
    html_string
  end

  def hikidoc_to_html(src)
    eval_hiki_plugin(HikiDoc.to_html(src, :level => 2))
  end

  def eval_hiki_plugin(html)
    html.gsub(/<(div|span) class=\"plugin\">\{\{\s*(.+)\}\}<\/(div|span)>/) {
      meth, *args = $2.split(/\s+/)
      __send__ 'bu_plugin_' + meth, *args
    }
  end
end
