require 'spec_helper'

describe Mode do
  describe "#switch" do
    it "initial state should be online" do
      expect(Mode).to be_online
      expect(Mode).not_to be_offline
    end

    context "when development environment" do
      before do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
      end

      it "should change mode to offline after the first switch and " +
        "back to online after the second" do
        Mode.switch
        expect(Mode).not_to be_online
        expect(Mode).to be_offline
        Mode.switch
        expect(Mode).to be_online
        expect(Mode).not_to be_offline
        Mode.switch
        expect(Mode).not_to be_online
        expect(Mode).to be_offline
      end
    end

    context "when not development environment" do
      before do
        env = double
        allow(Rails).to receive(:env).and_return(env)
        allow(env).to receive(:development?).and_return(false)
      end

      it "should raise an error" do
        expect { Mode.switch }.to raise_error(RuntimeError)
      end
    end
  end
end

