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

    fb.albums.each_with_index do |album, index|
      next unless include_albums.include?(album.name)

      html += <<-EOS
        <h2>#{album.name}</h2>
        <div id="gallery_#{index}" class="gallery" style="display:none; height: 400px;">
      EOS

      album.photos.each do |photo|
        html += <<-EOS
          <img alt="#{album.name} (#{photo.caption})" src="#{photo.thumbnail}"
            data-image="#{photo.source}"
            data-description="#{photo.caption}" />
        EOS
      end

      html += <<-EOS
        </div>
      EOS
    end

    html
  end

  Liquid::Template.register_tag "facebook_photos", self
end
