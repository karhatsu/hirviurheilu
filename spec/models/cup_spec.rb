require 'spec_helper'

describe Cup do
  it "create" do
    Factory.create(:cup)
  end
  
  describe "validation" do
    it { should validate_presence_of(:name) }
    
    it { should validate_numericality_of(:top_competitions) }
    it { should_not allow_value(nil).for(:top_competitions) }
    it { should_not allow_value(0).for(:top_competitions) }
    it { should_not allow_value(1).for(:top_competitions) }
    it { should allow_value(2).for(:top_competitions) }
    it { should_not allow_value(2.1).for(:top_competitions) }
  end
end
