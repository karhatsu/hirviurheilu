require 'spec_helper'

describe DefaultAgeGroup do
  it "should take name and min_competitors as init parameters" do
    dag = DefaultAgeGroup.new("Test group", 5)
    expect(dag.name).to eq("Test group")
    expect(dag.min_competitors).to eq(5)
  end
end
