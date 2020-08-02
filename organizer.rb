require "exifr/jpeg"
require "pry"

class Organizer
  def initialize(source_directory, destination_directory)
    @source_directory = ensure_trailing_slash(source_directory)
    @destination_directory = ensure_trailing_slash(destination_directory)
  end

  def ensure_trailing_slash(directory_path)
    if directory_path[-1] != "/"
      directory_path + "/"
    else
      directory_path
    end
  end

  def organize
    Dir.children(@source_directory).each do |item|
      next if File.directory?(item)

      source_photo_path = File.join(@source_directory, item)
      photo_year, photo_month = photo_time_parts(source_photo_path)

      if photo_year.nil?
        target_directory = @destination_directory + "0000-no-exif"
      else
        target_directory = @destination_directory + File.join(photo_year, photo_month)
      end

      FileUtils.mkdir_p(target_directory)

      if move?
        FileUtils.mv(source_photo_path, File.join(target_directory, item))
      else
        FileUtils.cp(source_photo_path, File.join(target_directory, item))
      end
    end
  end

  def move!
    @organize_mode = :move
  end

  def move?
    @organize_mode ||= :copy
    @organize_mode == :move
  end

  def photo_time_parts(photo_path)
      photo_date_time = EXIFR::JPEG.new(photo_path).date_time
      return nil if photo_date_time.nil?

      photo_year = photo_date_time.strftime("%Y")
      photo_month = photo_date_time.strftime("%m")
      return [photo_year, photo_month]
  end
end
