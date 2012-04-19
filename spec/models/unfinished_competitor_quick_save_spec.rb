require 'spec_helper'

describe UnfinishedCompetitorQuickSave do
  before do
    @race = FactoryGirl.create(:race)
    @series = FactoryGirl.create(:series, :race => @race)
    FactoryGirl.create(:competitor, :series => @series, :number => 1)
    @c = FactoryGirl.create(:competitor, :series => @series, :number => 10,
      :no_result_reason => Competitor::DNS)
    @c2 = FactoryGirl.create(:competitor, :series => @series, :number => 11)
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

  describe "unknown competitor" do
    before do
      another_race = FactoryGirl.create(:race)
      series = FactoryGirl.create(:series, :race => another_race)
      FactoryGirl.create(:competitor, :series => series, :number => 8)
      @qs = UnfinishedCompetitorQuickSave.new(@race.id, '8,dns')
    end

    it "should cause failed save" do
      check_failed_save @qs, /kilpailija/, false
    end
  end

  describe "invalid string format (1)" do
    before do
      @qs = UnfinishedCompetitorQuickSave.new(@race.id, '10,dng')
    end

    it "should cause failed save" do
      check_failed_save @qs, /muoto/, false, @c, Competitor::DNS
    end
  end

  describe "invalid string format (2)" do
    before do
      @qs = UnfinishedCompetitorQuickSave.new(@race.id, '10,dnfdns')
    end

    it "should cause failed save" do
      check_failed_save @qs, /muoto/, false, @c, Competitor::DNS
    end
  end

  describe "data already stored" do
    before do
      @c = FactoryGirl.create(:competitor, :series => @series, :number => 12,
        :no_result_reason => Competitor::DNF)
      @qs = UnfinishedCompetitorQuickSave.new(@race.id, '12,dns')
    end

    it "should cause failed save" do
      check_failed_save @qs, /talletettu/, true, @c, Competitor::DNF
    end
  end

  def check_failed_save(qs, error_regex, find_competitor,
      original_competitor=nil, original_reason=nil)
    qs.save.should be_false
    qs.error.should match(error_regex)
    qs.competitor.should be_nil unless find_competitor
    if original_competitor
      original_competitor.reload
      original_competitor.no_result_reason.should == original_reason
    end
  end
end
