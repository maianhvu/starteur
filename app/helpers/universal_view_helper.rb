module UniversalViewHelper

  # Constants
  PATH_TAGS_DEFAULT_META= 'shared/default_meta_tags'
  PATH_TAGS_FAVICON = 'shared/favicon_tags'

  def default_meta_tags
    render partial: PATH_TAGS_DEFAULT_META
  end

  def favicon_tags
    render partial: PATH_TAGS_FAVICON
  end

end
