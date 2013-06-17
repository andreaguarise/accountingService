module ApplicationHelper
  def upArrowLink (name)
    link_to "&uarr;".html_safe, :sort => name 
  end
  def downArrowLink (name)
    link_to "&darr;".html_safe, :sort => name , :desc => "true"
  end
end
