# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def highlight_twit(text)
    text.gsub!(/(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/) {|url| url = "<a href='#{url}'>#{url}</a>"}
    text.gsub(/@([a-zA-Z0-9_]*)/, '@<a class=\'user_link\' href=\'http://twitter.com/\1\' rel=\'nofollow\'>\1</a>')
  end
  
  def trim_text(text, length)
    return text if text.length <= length
    return text[0,length-1].strip() + "..."
  end
end
