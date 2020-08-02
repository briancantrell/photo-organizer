require "rspec"
require_relative "../organizer"

describe "organizer" do
  let(:source_directory) { "spec/fixtures/source_temp" }
  let(:destination_directory) { "spec/fixtures/destination_temp" }

  subject { Organizer.new(source_directory, destination_directory) }

  before do
    FileUtils.mkdir source_directory
    FileUtils.mkdir destination_directory

    FileUtils.cp_r Dir["spec/fixtures/images/*"], Dir[source_directory]
  end

  after do
    FileUtils.rm_rf source_directory
    FileUtils.rm_rf destination_directory
  end

  it "organizes photos into year/month directory based on exif datetime" do
    subject.organize

    expect(FileUtils.compare_file(
      File.join(source_directory, "Canon_40D.jpg"), 
      File.join(destination_directory, "2008", "07", "Canon_40D.jpg"))).to be_truthy

    expect(FileUtils.compare_file(
      File.join(source_directory, "BlueSquare.jpg"), 
      File.join(destination_directory, "2005", "09", "BlueSquare.jpg"))).to be_truthy

    expect(FileUtils.compare_file(
      File.join(source_directory, "canon-ixus.jpg"), 
      File.join(destination_directory, "2001", "06", "canon-ixus.jpg"))).to be_truthy
  end

  it "puts files without exif data in 0000-no-exif directory" do
    subject.organize

    expect(FileUtils.compare_file(
      File.join(source_directory, "00-45.jpeg"), 
      File.join(destination_directory, "0000-no-exif", "00-45.jpeg"))).to be_truthy
  end

  context "when organize mode is set to :copy" do
    it "leaves source images in the source directory" do
      subject.organize
      source_photos = Dir.children(source_directory)
      expect(source_photos.length).to eq 4
    end
  end

  context "when organize mode is set to :move" do
    it "empties the source image directory" do
      subject.move!
      subject.organize
      source_photos = Dir.children(source_directory)
      expect(source_photos.length).to eq 0
    end
  end

  describe "error handling" do
    it "raises an error if source or destination directories do not exist" do
      expect {
        Organizer.new("bogus/directory", destination_directory)
      }.to raise_error PhotoDirectoryNotFoundError

      expect {
        Organizer.new(source_directory, "bogus/directory")
      }.to raise_error PhotoDirectoryNotFoundError
    end
  end
end

