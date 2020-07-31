require "rspec"

describe "organizer" do
  let(:source_directory) { "fixtures/source_temp" }
  let(:destination_directory) { "fixtures/destination_temp" }

  subject { Organizer.new(Dir[source_directory], Dir[destination_directory]) }

  before do
    FileUtils.mkdir source_directory
    FileUtils.mkdir destination_directory

    FileUtils.cp_r Dir["fixtures/images/*"], Dir[source_directory]
    # Dir.entries(File.dirname(__FILE__) + "/spec/fixtures/images")
  end

  after do
    FileUtils.rm_rf source_directory
    FileUtils.rm_rf destination_directory
  end

  it "creates year and month subdirectories in destination directory" do
    subject.organize
  end

  it "organizes photos into the correct directory" do
    expect(true).to be_truthy
  end

  it "deletes organized images from source directory" do
  end


  context "destination month & year subdirectories already exist" do
    it "uses the existing directories" do

    end
  end
end

