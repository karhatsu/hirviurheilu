# encoding: UTF-8
require 'spec_helper'

describe EstimatesQuickSave do
  before do
    @race = Factory.create(:race)
    @series = Factory.create(:series, :race => @race)
    Factory.create(:competitor, :series => @series, :number => 1)
    @c = Factory.create(:competitor, :series => @series, :number => 10,
      :estimate1 => 1, :estimate2 => 2)
    @c2 = Factory.create(:competitor, :series => @series, :number => 11)
  end

  context "when string format is correct and competitor is found" do
    describe "successfull save" do
      describe "2 estimates" do
        before do
          @qs = EstimatesQuickSave.new(@race.id, '11,98,115')
        end

        describe "#save" do
          it "should save given 2 estimates for the competitor and return true" do
            @qs.save.should be_true
            @c2.reload
            @c2.estimate1.should == 98
            @c2.estimate2.should == 115
          end
        end

        describe "#competitor" do
          it "should return the correct competitor" do
            @qs.save
            @c.reload
            @qs.competitor.should == @c2
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
          @qs = EstimatesQuickSave.new(@race.id, '11,98,115,160,144')
        end

        describe "#save" do
          it "should save given 4 estimates for the competitor and return true" do
            @qs.save.should be_true
            @c2.reload
            @c2.estimate1.should == 98
            @c2.estimate2.should == 115
            @c2.estimate3.should == 160
            @c2.estimate4.should == 144
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
        @qs = EstimatesQuickSave.new(@race.id, '++10,111,122,80,90')
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
        @qs = EstimatesQuickSave.new(@race.id, '++10,111,122')
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
  describe "data already stored" do
    before do
      @c = Factory.create(:competitor, :series => @series, :number => 12,
        :estimate1 => 52)
      @qs = EstimatesQuickSave.new(@race.id, '12,98,102')
    end

    describe "#save" do
      it "should not save given estimates for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.estimate1.should == 52
      end
    end

    describe "#competitor" do
      it "should return competitor" do
        @qs.save
        @qs.competitor.should == @c
      end
    end

    describe "#error" do
      it "should contain data already stored message" do
        @qs.save
        @qs.error.should match(/talletettu/)
      end
    end
  end
end

