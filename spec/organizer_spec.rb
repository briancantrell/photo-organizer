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

  it "deletes organized images from source directory" do
  end


  context "destination month & year subdirectories already exist" do
    it "uses the existing directories" do

    end
  end
end

