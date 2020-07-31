class Organizer
  def init(source_directory, destination_directory)
    @source_directory = source_directory
    @destination_directory = destination_directory
  end

  def organize
    @source_directory.each do |image|
      puts image
      puts EXIFR::JPEG.new(image).width.to_s

      # Dir["spec/fixtures/images/*"]
    end
  end

end
