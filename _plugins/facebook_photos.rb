require "json"
require_relative "remote_facebook_photos"

Album = Struct.new(:id, :name, :created_time, :photos)
Photo = Struct.new(:id, :caption, :images) do
  def thumbnail
    second_smallest_image
  end

  def source
    biggest_image
  end

  def second_smallest_image
    images.sort_by { |image| image["height"] + image["width"] }[1]["source"]
  end

  def biggest_image
    images.sort_by { |image| image["height"] + image["width"] }.last["source"]
  end
end

class FacebookPhotos
  attr_reader :albums

  def initialize(app_id, app_secret, callback_url, username, exclude_albums)
    @app_id = app_id
    @app_secret = app_secret
    @callback_url = callback_url
    @username = username
    @exclude_albums = exclude_albums

    @albums = get_data_for_albums.map do |album_data|
      album = Album.new

      album.id = album_data["id"]
      album.name = album_data["name"]
      album.created_time = album_data["created_time"]

      album.photos = get_data_for_photos(album.id).map do |photo_data|
        photo = Photo.new
        photo.id = photo_data["id"]
        photo.caption = photo_data["name"]
        photo.images = photo_data["images"]

        photo
      end

      album
    end
  end

  private

  def force_download?
    ENV["FORCE_FACEBOOK_DATA_DOWNLOAD"] == "true"
  end

  def use_local_albums?
    return false if force_download?

    local_albums_exist?
  end

  def use_local_photos?(album_id)
    return false if force_download?

    local_photos_exist?(album_id)
  end

  def local_albums_exist?
    File.exist?(albums_path)
  end

  def local_photos_exist?(album_id)
    File.exist?(photos_path(album_id))
  end

  def get_data_for_albums
    albums = []

    if use_local_albums?
      albums = load(albums_path)
    elsif @app_secret.nil?
      abort "Configuration setting facebook.app_secret not set."
    else
      @remote ||= RemoteFacebookPhotos.new(@app_id, @app_secret, @callback_url)
      albums = @remote.get_albums(@username, @exclude_albums)
      save(count: albums.count, data: albums.to_json, path: albums_path)
    end

    albums
  end

  def get_data_for_photos(album_id)
    photos = []

    if use_local_photos?(album_id)
      photos = load(photos_path(album_id))
    else
      @remote ||= RemoteFacebookPhotos.new(@app_id, @app_secret, @callback_url)
      photos = @remote.get_photos(album_id)
      save(count: photos.count, data: photos.to_json, path: photos_path(album_id))
    end

    photos
  end

  def load(path)
    JSON.load(File.open(path))
  end

  def save(count:, path:, data:)
    File.open(path, "w") do |f|
      f.write(data)
    end

    puts "Saved #{count} items to #{path}."
  end

  def albums_path
    File.join("_data", "facebook", "albums.json")
  end

  def photos_path(album_id)
    File.join("_data", "facebook", "photos_#{album_id}.json")
  end
end
