module UniversalViewHelper

  # Constants
  PATH_TAGS_DEFAULT_META= 'shared/default_meta_tags'
  PATH_TAGS_FAVICON = 'shared/favicon_tags'
  PATH_FOOTER = 'shared/footer'

  SIZES_APPLE_TOUCH_ICONS = [57, 60, 72, 76, 114, 120, 144, 152, 180]

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

  # ------------------------------------------------------------------------------------------------
  # FAVICON TAGS
  # ------------------------------------------------------------------------------------------------
  def apple_touch_icons
    SIZES_APPLE_TOUCH_ICONS.map { |size|
      # Determine size in the form of sizexsize
      raw_size = "#{size}x#{size}"
      icon_url = root_path + "apple-touch-icon-#{raw_size}.png"
      favicon_link_tag icon_url, rel: 'apple-touch-icon', sizes: raw_size
    }.join('')
  end

end
