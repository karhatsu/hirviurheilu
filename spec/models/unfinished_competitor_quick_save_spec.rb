require 'spec_helper'

describe UnfinishedCompetitorQuickSave do
  before do
    @race = Factory.create(:race)
    @series = Factory.create(:series, :race => @race)
    Factory.create(:competitor, :series => @series, :number => 1)
    @c = Factory.create(:competitor, :series => @series, :number => 10,
      :no_result_reason => Competitor::DNS)
    @c2 = Factory.create(:competitor, :series => @series, :number => 11)
  end

  context "when string format is correct and competitor is found" do
    describe "successfull save" do
      before do
        @qs = UnfinishedCompetitorQuickSave.new(@race.id, '11,dns')
      end

      describe "#save" do
        it "should save given status for the competitor and return true" do
          @qs.save.should be_true
          @c2.reload
          @c2.no_result_reason.should == Competitor::DNS
        end
      end

      describe "#competitor" do
        it "should return the correct competitor" do
          @qs.save
          @c2.reload
          @qs.competitor.should == @c2
        end
      end

      describe "#error" do
        it "should be nil" do
          @qs.save
          @qs.error.should be_nil
        end
      end

      describe "with overwrite" do
        before do
          @qs = UnfinishedCompetitorQuickSave.new(@race.id, '++10,dnf')
        end

        describe "#save" do
          it "should save given no result reason for the competitor and return true" do
            @qs.save.should be_true
            @c.reload
            @c.no_result_reason.should == Competitor::DNF
          end
        end

        describe "#competitor" do
          it "should return the correct competitor" do
            @qs.save
            @c.reload
            @qs.competitor.should == @c
          end
        end

        describe "#error" do
          it "should be nil" do
            @qs.save
            @qs.error.should be_nil
          end
        end
      end
    end
  end
end

