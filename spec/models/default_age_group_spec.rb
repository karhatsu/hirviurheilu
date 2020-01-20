require 'spec_helper'

describe DefaultAgeGroup do
  context "when children's group" do
    it 'should set 0 as min competitors' do
      expect_age_group 'T15', 0
      expect_age_group 'P9', 0
    end
  end

  context "when adult's group" do
    it 'should set 2 as min competitors' do
      expect_age_group 'M65', 2
      expect_age_group 'N75', 2
    end
  end

  def expect_age_group(name, min_competitors)
    dag = DefaultAgeGroup.new name
    expect(dag.name).to eql name
    expect(dag.min_competitors).to eql min_competitors
  end
end
