require 'spec_helper'

describe ShotsQuickSave do
  before do
    @race = FactoryGirl.create(:race)
    series = FactoryGirl.create(:series, :race => @race)
    FactoryGirl.create(:competitor, :series => series, :number => 1)
    @c = FactoryGirl.create(:competitor, :series => series, :number => 10,
      :shots_total_input => 50)
    @c2 = FactoryGirl.create(:competitor, :series => series, :number => 11)
  end

  context "when string format is correct and competitor is found" do
    describe "successfull save" do
      describe "shots sum" do
        context "when competitor has shots total input" do
          before do
            @qs = ShotsQuickSave.new(@race.id, '11,98')
          end

          describe "#save" do
            it "should save given shots sum for the competitor and return true" do
              expect(@qs.save).to be_true
              @c2.reload
              expect(@c2.shots_total_input).to eq(98)
            end
          end

          describe "#competitor" do
            it "should return the correct competitor" do
              @qs.save
              @c2.reload
              expect(@qs.competitor).to eq(@c2)
            end
          end

          describe "#error" do
            it "should be nil" do
              @qs.save
              expect(@qs.error).to be_nil
            end
          end
        end

        context "when competitor has invidivual shots" do
          before do
            @c2.shots_total_input = nil
            @c2.shots << FactoryGirl.build(:shot, :competitor => @c2, :value => 10)
            @c2.save!
            @qs = ShotsQuickSave.new(@race.id, '++11,98')
          end

          describe "#save" do
            it "should save given shots sum for the competitor and return true" do
              expect(@qs.save).to be_true
              @c2.reload
              expect(@c2.shots_total_input).to eq(98)
            end
          end

          describe "#competitor" do
            it "should return the correct competitor" do
              @qs.save
              @c2.reload
              expect(@qs.competitor).to eq(@c2)
            end
          end

          describe "#error" do
            it "should be nil" do
              @qs.save
              expect(@qs.error).to be_nil
            end
          end
        end
      end

      describe "individual shots" do
        context "when competitor has shots total input" do
          before do
            @qs = ShotsQuickSave.new(@race.id, '++10,+998876510')
          end

          describe "#save" do
            it "should save given shots for the competitor and return true" do
              expect(@qs.save).to be_true
              @c.reload
              expect(@c.shots_total_input).to be_nil
              expect(@c.shots.size).to eq(10)
              expect(@c.shots_sum).to eq(10+9+9+8+8+7+6+5+1+0)
            end
          end

          describe "#competitor" do
            it "should return the correct competitor" do
              @qs.save
              @c.reload
              expect(@qs.competitor).to eq(@c)
            end
          end

          describe "#error" do
            it "should be nil" do
              @qs.save
              expect(@qs.error).to be_nil
            end
          end
        end

        context "when competitor has individual shots" do
          before do
            @c.shots_total_input = nil
            @c.shots << FactoryGirl.build(:shot, :competitor => @c, :value => 10)
            @c.save!
            @qs = ShotsQuickSave.new(@race.id, '++10,+998876501')
          end

          describe "#save" do
            it "should save given shots for the competitor and return true" do
              expect(@qs.save).to be_true
              @c.reload
              expect(@c.shots_total_input).to be_nil
              expect(@c.shots.size).to eq(10)
              expect(@c.shots_sum).to eq(10+9+9+8+8+7+6+5+0+1)
            end
          end

          describe "#competitor" do
            it "should return the correct competitor" do
              @qs.save
              @c.reload
              expect(@qs.competitor).to eq(@c)
            end
          end

          describe "#error" do
            it "should be nil" do
              @qs.save
              expect(@qs.error).to be_nil
            end
          end
        end
      end
    end

    describe "save fails" do
      before do
        @qs = ShotsQuickSave.new(@race.id, '10,200') # 200 > 100
      end

      describe "#save" do
        it "should not save given shots for the competitor and return false" do
          expect(@qs.save).to be_false
          @c.reload
          expect(@c.shots_total_input).to eq(50)
        end
      end

      describe "#competitor" do
        it "should return the correct competitor" do
          @qs.save
          @c.reload
          expect(@qs.competitor).to eq(@c)
        end
      end

      describe "#error" do
        it "should contain an error message" do
          @qs.save
          expect(@qs.error).not_to be_nil
        end
      end
    end
  end

  describe "unknown competitor" do
    before do
      another_race = FactoryGirl.create(:race)
      series = FactoryGirl.create(:series, :race => another_race)
      FactoryGirl.create(:competitor, :series => series, :number => 8)
      @qs = ShotsQuickSave.new(@race.id, '8,98')
    end

    describe "#save" do
      it "should not save given shots for the competitor and return false" do
        expect(@qs.save).to be_false
        @c.reload
        expect(@c.shots_total_input).to eq(50)
      end
    end

    describe "#competitor" do
      it "should return nil" do
        @qs.save
        expect(@qs.competitor).to be_nil
      end
    end

    describe "#error" do
      it "should contain competitor error message" do
        @qs.save
        expect(@qs.error).to match(/kilpailija/)
      end
    end
  end

  describe "invalid string format" do
    before do
      @qs = ShotsQuickSave.new(@race.id, '8,8x')
    end

    describe "#save" do
      it "should not save given shots for the competitor and return false" do
        expect(@qs.save).to be_false
        @c.reload
        expect(@c.shots_total_input).to eq(50)
      end
    end

    describe "#competitor" do
      it "should return nil" do
        @qs.save
        expect(@qs.competitor).to be_nil
      end
    end

    describe "#error" do
      it "should contain invalid format error message" do
        @qs.save
        expect(@qs.error).to match(/muoto/)
      end
    end
  end

  describe "data already stored" do
    before do
      series = FactoryGirl.create(:series, :race => @race)
      @c = FactoryGirl.create(:competitor, :series => series, :number => 12,
        :shots_total_input => 50)
      @qs = ShotsQuickSave.new(@race.id, '12,++++998870')
    end

    describe "#save" do
      it "should not save given shots for the competitor and return false" do
        expect(@qs.save).to be_false
        @c.reload
        expect(@c.shots_total_input).to eq(50)
      end
    end

    describe "#competitor" do
      it "should return competitor" do
        @qs.save
        expect(@qs.competitor).to eq(@c)
      end
    end

    describe "#error" do
      it "should contain data already stored message" do
        @qs.save
        expect(@qs.error).to match(/talletettu/)
      end
    end
  end
end

