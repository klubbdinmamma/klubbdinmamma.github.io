require "koala"

class RemoteFacebookPhotos
  attr_reader :graph

  def initialize(app_id, app_secret, callback_url)
    Koala.config.api_version = "v3.1"
    oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    access_token = oauth.get_app_access_token
    @graph = Koala::Facebook::API.new(access_token)
  end

  def get_albums(username, exclude_albums)
    puts "Fetching albums for \"#{username}\" ..."

    albums = graph.get_object("#{username}/albums")

    all_albums = get_all(albums)
    all_albums.reject! { |album| exclude_albums.include?(album["name"]) }
  end

  def get_photos(album_id)
    puts "Fetching all photos for album \"#{album_id}\"..."

    photos = graph.get_object("#{album_id}/photos?fields=picture,images,name")

    get_all(photos)
  end

  private

  def get_all(graph_collection)
    full_collection = []

    loop do
      unless graph_collection.nil?
        full_collection += graph_collection.raw_response["data"]
      else
        break()
      end

      graph_collection = graph_collection.next_page
    end

    full_collection
  end
end
