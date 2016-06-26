require "json"
require_relative "remote_facebook_photos"

Album = Struct.new(:id, :name, :created_time, :photos)
Photo = Struct.new(:id, :caption, :source, :thumbnail)

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
        photo.thumbnail = photo_data["picture"]
        photo.source = photo_data["images"].sort_by { |image| image["height"] + image["width"] }.last["source"]

        photo
      end

      album
    end
  end

  private

  def local_albums_exist?
    File.exist?(albums_path)
  end

  def local_photos_exist?(album_id)
    File.exist?(photos_path(album_id))
  end

  def get_data_for_albums
    albums = []

    if local_albums_exist?
      albums = JSON.load(File.open(albums_path))
    else
      @remote ||= RemoteFacebookPhotos.new(@app_id, @app_secret, @callback_url)
      albums = @remote.get_albums(@username, @exclude_albums)
      save(count: albums.count, data: albums.to_json, path: albums_path, type: :albums)
    end

    albums
  end

  def get_data_for_photos(album_id)
    photos = []

    if local_photos_exist?(album_id)
      photos = JSON.load(File.open(photos_path(album_id)))
    else
      @remote ||= RemoteFacebookPhotos.new(@app_id, @app_secret, @callback_url)
      photos = @remote.get_photos(album_id)
      save(count: photos.count, data: photos.to_json, path: photos_path(album_id), type: :photos)
    end

    photos
  end

  def save(count:, type:, path:, data:)
    File.open(path, "w") do |f|
      f.write(data)
    end

    puts "Saved #{count} #{type} to #{path}."
  end

  def albums_path
    "_data/albums.json"
  end

  def photos_path(album_id)
    "_data/photos_#{album_id}.json"
  end
end
