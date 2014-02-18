require 'spec_helper'

describe Mode do
  describe "#switch" do
    it "initial state should be online" do
      Mode.should be_online
      Mode.should_not be_offline
    end

    context "when development environment" do
      before do
        Rails.stub(:env).and_return(ActiveSupport::StringInquirer.new('development'))
      end

      it "should change mode to offline after the first switch and " +
        "back to online after the second" do
        Mode.switch
        Mode.should_not be_online
        Mode.should be_offline
        Mode.switch
        Mode.should be_online
        Mode.should_not be_offline
        Mode.switch
        Mode.should_not be_online
        Mode.should be_offline
      end
    end

    context "when not development environment" do
      before do
        Rails.stub(:env).and_return('production')
      end

      it "should raise an error" do
        lambda { Mode.switch }.should raise_error
      end
    end
  end
end

