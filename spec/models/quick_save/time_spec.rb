require 'spec_helper'

describe QuickSave::Time do
  before do
    @race = create(:race)
    @series = create(:series, :race => @race, name: 'M45')
    create(:competitor, :series => @series, :number => 1,
      :start_time => '01:00:00')
    @c = create(:competitor, :series => @series, :number => 10,
      :start_time => '01:30:00', :arrival_time => '02:00:00')
    @c2 = create(:competitor, :series => @series, :number => 11,
      :start_time => '01:30:00')
  end

  context "when string format is correct and competitor is found" do
    describe "successfull save" do
      before do
        @qs = QuickSave::Time.new(@race.id, '11,031259')
      end

      describe "#save" do
        it "should save given time for the competitor and return true" do
          expect(@qs.save).to be_truthy
          @c2.reload
          expect(@c2.arrival_time.strftime('%H:%M:%S')).to eq('03:12:59')
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
          @qs = QuickSave::Time.new(@race.id, '++10,031259')
        end

        describe "#save" do
          it "should save given time for the competitor and return true" do
            expect(@qs.save).to be_truthy
            @c.reload
            expect(@c.arrival_time.strftime('%H:%M:%S')).to eq('03:12:59')
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
        @c = create(:competitor, :series => @series, :number => 8) # no start time
        @qs = QuickSave::Time.new(@race.id, '8,031245')
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
      another_race = create(:race)
      series = create(:series, :race => another_race)
      create(:competitor, :series => series, :number => 8,
        :start_time => '01:00:00')
      @qs = QuickSave::Time.new(@race.id, '8,031209')
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
      @qs = QuickSave::Time.new(@race.id, '10,0312451')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        expect(@qs.save).to be_falsey
        @c.reload
        expect(@c.arrival_time.strftime('%H:%M:%S')).to eq('02:00:00')
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
      @qs = QuickSave::Time.new(@race.id, '10,271213')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        expect(@qs.save).to be_falsey
        @c.reload
        expect(@c.arrival_time.strftime('%H:%M:%S')).to eq('02:00:00')
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
      @c = create(:competitor, :series => @series, :number => 12,
        :start_time => '01:30:00', :arrival_time => '02:00:00', first_name: 'Mikko', last_name: 'Miettinen')
      @qs = QuickSave::Time.new(@race.id, '12,031245')
    end

    describe "#save" do
      it "should not save given time for the competitor and return false" do
        expect(@qs.save).to be_falsey
        @c.reload
        expect(@c.arrival_time.strftime('%H:%M:%S')).to eq('02:00:00')
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

  context 'when # is used instead of ,' do
    context 'and input is valid' do
      it 'saves result' do
        @qs = QuickSave::Time.new(@race.id, '11#014541')
        expect(@qs.save).to be_truthy
        expect(@c2.reload.arrival_time.strftime('%H:%M:%S')).to eq('01:45:41')
      end
    end
  end
end
