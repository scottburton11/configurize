require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module ConfigurableThing
  extend Configurize
end

module ConfigHelpers
  def sample_config
    {:one => "two", :three => 4}
  end
end

describe Configurize, "using the hash key literal" do
  include ConfigHelpers
  
  before(:each) do
    ConfigurableThing.should_receive(:config).and_return(sample_config)
  end

  it "returns the value identified by the key provided" do
    ConfigurableThing[:one].should eql("two")
  end

end

describe Configurize, "using the hash key assignment literal" do

  before(:each) do
    ConfigurableThing.should_receive(:load_config).and_return({})
    ConfigurableThing.should_receive(:write_config).and_return(true)
  end

  it "writes the value to the key provided" do
    ConfigurableThing[:foo] = "bar"
    ConfigurableThing[:foo].should eql("bar")
  end

end

describe Configurize, "config file" do
  include ConfigHelpers

  it "name is determined by the mixed-in class" do
    ConfigurableThing.send(:config_file_name).should eql("configurable_thing.yml")
  end

  it "is provided to YAML.load_file" do
    File.stub!(:exists?).and_return(true)
    ConfigurableThing.stub!(:config_file_path).and_return("/config/configurable_thing.yml")
    YAML.should_receive(:load_file).with("/config/configurable_thing.yml").and_return(sample_config)
    ConfigurableThing.send(:load_config)
  end

end

