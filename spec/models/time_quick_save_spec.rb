require 'spec_helper'

describe TimeQuickSave do
  before do
    @race = FactoryGirl.create(:race)
    @series = FactoryGirl.create(:series, :race => @race, name: 'M45')
    FactoryGirl.create(:competitor, :series => @series, :number => 1,
      :start_time => '11:00:00')
    @c = FactoryGirl.create(:competitor, :series => @series, :number => 10,
      :start_time => '11:30:00', :arrival_time => '12:00:00')
    @c2 = FactoryGirl.create(:competitor, :series => @series, :number => 11,
      :start_time => '11:30:00')
  end

  context "when string format is correct and competitor is found" do
    describe "successfull save" do
      before do
        @qs = TimeQuickSave.new(@race.id, '11,131259')
      end

      describe "#save" do
        it "should save given time for the competitor and return true" do
          expect(@qs.save).to be_truthy
          @c2.reload
          expect(@c2.arrival_time.strftime('%H:%M:%S')).to eq('13:12:59')
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

      describe "with overwrite" do
        before do
          @qs = TimeQuickSave.new(@race.id, '++10,131259')
        end

        describe "#save" do
          it "should save given time for the competitor and return true" do
            expect(@qs.save).to be_truthy
            @c.reload
            expect(@c.arrival_time.strftime('%H:%M:%S')).to eq('13:12:59')
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

    describe "save fails" do
      before do
        @c = FactoryGirl.create(:competitor, :series => @series, :number => 8) # no start time
        @qs = TimeQuickSave.new(@race.id, '8,131245')
      end

      describe "#save" do
        it "should not save given time for the competitor and return false" do
          expect(@qs.save).to be_falsey
          @c.reload
          expect(@c.arrival_time).to be_nil
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
      FactoryGirl.create(:competitor, :series => series, :number => 8,
        :start_time => '11:00:00')
      @qs = TimeQuickSave.new(@race.id, '8,131209')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        expect(@qs.save).to be_falsey
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

  describe "invalid string format (1)" do
    before do
      @qs = TimeQuickSave.new(@race.id, '10,1312451')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        expect(@qs.save).to be_falsey
        @c.reload
        expect(@c.arrival_time.strftime('%H:%M:%S')).to eq('12:00:00')
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

  describe "invalid string format (2)" do
    before do
      @qs = TimeQuickSave.new(@race.id, '10,271213')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        expect(@qs.save).to be_falsey
        @c.reload
        expect(@c.arrival_time.strftime('%H:%M:%S')).to eq('12:00:00')
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
      @c = FactoryGirl.create(:competitor, :series => @series, :number => 12,
        :start_time => '11:30:00', :arrival_time => '12:00:00', first_name: 'Mikko', last_name: 'Miettinen')
      @qs = TimeQuickSave.new(@race.id, '12,131245')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        expect(@qs.save).to be_falsey
        @c.reload
        expect(@c.arrival_time.strftime('%H:%M:%S')).to eq('12:00:00')
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
        expect(@qs.error).to eq('Kilpailijalle (Mikko Miettinen, M45) on jo talletettu tieto. Voit ylikirjoittaa vanhan tuloksen syöttämällä ++numero,tulos.')
      end
    end
  end
end

