require "./spec_helper"

describe Coscan do
  Coscan::Workers.new.create_dirs

  it "create tmp dir" do
    Dir.exists?("tmp").should eq(true)
  end

  it "create dat dir" do
    Dir.exists?("dat").should eq(true)
  end
end
