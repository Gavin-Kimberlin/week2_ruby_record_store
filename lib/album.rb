class Album
  attr_accessor :name
  attr_reader :id

  @@albums = {}
  @@total_rows = 0

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_albums = DB.exec("SELECT * FROM albums;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums
  end

  def self.all_alphebetized
    returned_albums = DB.exec("SELECT * FROM albums ORDER BY name;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums
  end

  def save
    result = DB.exec("INSERT INTO albums (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(album_to_compare)
    if album_to_compare
      self.name() == album_to_compare.name()
    else
      nil
    end
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    if name
      name = album.fetch("name")
      id = album.fetch("id").to_i
      Album.new({:name => name, :id => id})
    else
      nil
    end
  end

  def update(name)
    @name = name
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
    # SELECT column_name(s)
    # FROM table_name
    # WHERE EXISTS
    # (SELECT column_name FROM table_name WHERE condition);
  end

  def delete
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};") # new code
  end

  def songs
    Song.find_by_album(self.id)
  end
end
