module HtmlCompilerHelper
  def html_compiler(str)
    if str =~ /\A__hikidoc__/
      str.sub! /\A__hikidoc__\s*/, ''
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
    html.gsub(/<(div|span) class=\"plugin\">\{\{\s*(.+)\}\}<\/(div|span)>/) { eval('bu_plugin_' + $2) }
  end

  def bu_plugin_amazon(asin, opts = {})
    if opts[:text]
      amazon_text(asin, opts[:text])
    else
      amazon_img(asin)
    end
  end

  def amazon_text(asin, text)
    <<-HTML
      <a href="http://www.amazon.co.jp/o/ASIN/#{asin}/#{amazonid}">#{text}</a>
    HTML
  end

  def amazon_img(asin)
    <<-HTML
      <div class="amazon">
      <iframe src="http://rcm-jp.amazon.co.jp/e/cm?t=#{amazonid}&o=9&p=8&l=as1&asins=#{asin}&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
      </div>
    HTML
  end

  def amazonid
    'bukt-22'
  end
end
