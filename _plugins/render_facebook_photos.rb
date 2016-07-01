require_relative "facebook_photos"

class RenderFacebookPhotos < Liquid::Tag
  def initialize(tagName, text, tokens)
    super
    @text = text
  end

  def render(context)
    config = context.registers[:site].config

    app_id         = config.fetch("facebook").fetch("app_id")
    app_secret     = config.fetch("facebook").fetch("app_secret")
    callback_url   = config.fetch("facebook").fetch("callback_url")
    username       = config.fetch("facebook").fetch("username")
    exclude_albums = config.fetch("facebook").fetch("exclude_albums_from_download")
    include_albums = config.fetch("facebook").fetch("include_albums_in_html")

    fb = FacebookPhotos.new(app_id, app_secret, callback_url, username, exclude_albums)

    html = ""

    fb.albums.each do |album|
      next unless include_albums.include?(album.name)

      html << "<div class='facebook-photos'>\n"
      html << "  <h2>#{album.name}</h2>\n"

      album.photos.each do |photo|
        html << "  <a href='#{photo.source}' title='#{photo.caption}'>\n"
        html << "    <img src='#{photo.thumbnail}' height='100' width='100'>\n"
        html << "  </a>\n"
      end

      html << "</div>\n"
    end

    html
  end

  Liquid::Template.register_tag "facebook_photos", self
end
