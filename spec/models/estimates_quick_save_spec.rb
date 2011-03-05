require 'spec_helper'

describe EstimatesQuickSave do
  before do
    @race = Factory.create(:race)
    @series = Factory.create(:series, :race => @race)
    Factory.create(:competitor, :series => @series, :number => 1)
    @c = Factory.create(:competitor, :series => @series, :number => 10,
      :estimate1 => 1, :estimate2 => 2)
  end

  context "when string format is correct and competitor is found" do
    describe "successfull save" do
      describe "2 estimates" do
        before do
          @qs = EstimatesQuickSave.new(@race.id, '10,98,115')
        end

        describe "#save" do
          it "should save given 2 estimates for the competitor and return true" do
            @qs.save.should be_true
            @c.reload
            @c.estimate1.should == 98
            @c.estimate2.should == 115
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

      describe "4 estimates" do
        before do
          @series.estimates = 4
          @series.save!
          @qs = EstimatesQuickSave.new(@race.id, '10,98,115,160,144')
        end

        describe "#save" do
          it "should save given 4 estimates for the competitor and return true" do
            @qs.save.should be_true
            @c.reload
            @c.estimate1.should == 98
            @c.estimate2.should == 115
            @c.estimate3.should == 160
            @c.estimate4.should == 144
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

    describe "save fails" do
      before do
        @qs = EstimatesQuickSave.new(@race.id, '10,0,0')
      end

      describe "#save" do
        it "should not save given estimates for the competitor and return false" do
          @qs.save.should be_false
          @c.reload
          @c.estimate1.should == 1
          @c.estimate2.should == 2
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
        it "should contain an error message" do
          @qs.save
          @qs.error.should_not be_nil
        end
      end
    end

    describe "trying to save 4 estimates for a competitor of the series with 2 estimates" do
      before do
        @qs = EstimatesQuickSave.new(@race.id, '10,111,122,80,90')
      end

      describe "#save" do
        it "should not save given estimates for the competitor and return false" do
          @qs.save.should be_false
          @c.reload
          @c.estimate1.should == 1
          @c.estimate2.should == 2
          @c.estimate3.should be_nil
          @c.estimate4.should be_nil
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
        it "should contain an error message" do
          @qs.save
          @qs.error.should match(/täytyy syöttää kaksi ennustetta/)
        end
      end
    end

    describe "trying to save 2 estimates for a competitor of the series with 4 estimates" do
      before do
        @series.estimates = 4
        @series.save!
        @qs = EstimatesQuickSave.new(@race.id, '10,111,122')
      end

      describe "#save" do
        it "should not save given estimates for the competitor and return false" do
          @qs.save.should be_false
          @c.reload
          @c.estimate1.should == 1
          @c.estimate2.should == 2
          @c.estimate3.should be_nil
          @c.estimate4.should be_nil
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
        it "should contain an error message" do
          @qs.save
          @qs.error.should match(/täytyy syöttää neljä ennustetta/)
        end
      end
    end
  end

  describe "unknown competitor" do
    before do
      another_race = Factory.create(:race)
      series = Factory.create(:series, :race => another_race)
      Factory.create(:competitor, :series => series, :number => 8)
      @qs = EstimatesQuickSave.new(@race.id, '8,98,115')
    end

    describe "#save" do
      it "should not save given estimates for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.estimate1.should == 1
        @c.estimate2.should == 2
      end
    end

    describe "#competitor" do
      it "should return nil" do
        @qs.save
        @qs.competitor.should be_nil
      end
    end

    describe "#error" do
      it "should contain competitor error message" do
        @qs.save
        @qs.error.should match(/kilpailija/)
      end
    end
  end

  describe "invalid string format" do
    before do
      @qs = EstimatesQuickSave.new(@race.id, '8,98,')
    end

    describe "#save" do
      it "should not save given estimates for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.estimate1.should == 1
        @c.estimate2.should == 2
      end
    end

    describe "#competitor" do
      it "should return nil" do
        @qs.save
        @qs.competitor.should be_nil
      end
    end

    describe "#error" do
      it "should contain invalid format error message" do
        @qs.save
        @qs.error.should match(/muoto/)
      end
    end
  end
end

