require_relative "facebook_photos"

class RenderFacebookPhotos < Liquid::Tag
  def initialize(tagName, text, tokens)
    super
    @text = text
  end

  def render(context)
    config = context.registers[:site].config

    app_id         = config.fetch("facebook").fetch("app_id")
    app_secret     = config.fetch("facebook").fetch("app_secret", nil)
    callback_url   = config.fetch("facebook").fetch("callback_url")
    username       = config.fetch("facebook").fetch("username")
    exclude_albums = config.fetch("facebook").fetch("exclude_albums_from_download")
    include_albums = config.fetch("facebook").fetch("include_albums_in_html")
    num_of_photos  = config.fetch("facebook").fetch("number_of_photos_to_show_per_album", 10).to_i

    fb = FacebookPhotos.new(app_id, app_secret, callback_url, username, exclude_albums)

    albums_html = ""
    albums_links = []

    fb.albums.each_with_index do |album, index|
      next unless include_albums.include?(album.name)

      link_id = index

      albums_links << %Q(<a href="##{link_id}">#{album.name}</a>)

      albums_html += <<-EOS
        <a class="anchor" name="#{link_id}"></a>
        <h2>#{album.name}</h2>
        <div id="gallery_#{index}" class="gallery" style="display:none; height: 400px;">
      EOS

      album.photos.sample(num_of_photos).each do |photo|
        albums_html += <<-EOS
          <img alt="#{album.name} (#{photo.caption})" src="#{photo.thumbnail}"
            data-image="#{photo.source}"
            data-description="#{photo.caption}" />
        EOS
      end

      albums_html += <<-EOS
        </div>
      EOS
    end

    albums_links_html = albums_links.join(" • ")

    "<p>#{albums_links_html}</p>#{albums_html}"
  end

  Liquid::Template.register_tag "facebook_photos", self
end
