require 'spec_helper'

describe TimeQuickSave do
  before do
    @race = Factory.create(:race)
    @series = Factory.create(:series, :race => @race)
    Factory.create(:competitor, :series => @series, :number => 1,
      :start_time => '11:00:00')
    @c = Factory.create(:competitor, :series => @series, :number => 10,
      :start_time => '11:30:00', :arrival_time => '12:00:00')
    @c2 = Factory.create(:competitor, :series => @series, :number => 11,
      :start_time => '11:30:00')
  end

  context "when string format is correct and competitor is found" do
    describe "successfull save" do
      before do
        @qs = TimeQuickSave.new(@race.id, '11,131259')
      end

      describe "#save" do
        it "should save given time for the competitor and return true" do
          @qs.save.should be_true
          @c2.reload
          @c2.arrival_time.strftime('%H:%M:%S').should == '13:12:59'
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
          @qs = TimeQuickSave.new(@race.id, '++10,131259')
        end

        describe "#save" do
          it "should save given time for the competitor and return true" do
            @qs.save.should be_true
            @c.reload
            @c.arrival_time.strftime('%H:%M:%S').should == '13:12:59'
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
        @c = Factory.create(:competitor, :series => @series, :number => 8) # no start time
        @qs = TimeQuickSave.new(@race.id, '8,131245')
      end

      describe "#save" do
        it "should not save given time for the competitor and return false" do
          @qs.save.should be_false
          @c.reload
          @c.arrival_time.should be_nil
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
  end

  describe "unknown competitor" do
    before do
      another_race = Factory.create(:race)
      series = Factory.create(:series, :race => another_race)
      Factory.create(:competitor, :series => series, :number => 8,
        :start_time => '11:00:00')
      @qs = TimeQuickSave.new(@race.id, '8,131209')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        @qs.save.should be_false
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

  describe "invalid string format (1)" do
    before do
      @qs = TimeQuickSave.new(@race.id, '10,1312451')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.arrival_time.strftime('%H:%M:%S').should == '12:00:00'
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

  describe "invalid string format (2)" do
    before do
      @qs = TimeQuickSave.new(@race.id, '10,271213')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.arrival_time.strftime('%H:%M:%S').should == '12:00:00'
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
        :start_time => '11:30:00', :arrival_time => '12:00:00')
      @qs = TimeQuickSave.new(@race.id, '12,131245')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.arrival_time.strftime('%H:%M:%S').should == '12:00:00'
      end
    end

    describe "#competitor" do
      it "should return nil" do
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

