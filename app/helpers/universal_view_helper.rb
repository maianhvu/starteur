module UniversalViewHelper

  # Constants
  PATH_TAGS_DEFAULT_META= 'shared/default_meta_tags'
  PATH_TAGS_FAVICON = 'shared/favicon_tags'
  PATH_FOOTER = 'shared/footer'

  def default_meta_tags
    render partial: PATH_TAGS_DEFAULT_META
  end

  def favicon_tags
    render partial: PATH_TAGS_FAVICON
  end

  def include_script(script_name)
    @included_scripts ||= []
    @included_scripts << script_name
  end

  def included_scripts
    javascript_include_tag(*@included_scripts)
  end

  def footer
    render partial: PATH_FOOTER
  end

end
