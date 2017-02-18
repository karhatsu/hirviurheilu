require 'spec_helper'

describe UnfinishedCompetitorQuickSave do
  before do
    @race = create(:race)
    @series = create(:series, :race => @race)
    create(:competitor, :series => @series, :number => 1)
    @c = create(:competitor, :series => @series, :number => 10,
      :no_result_reason => Competitor::DNS)
    @c2 = create(:competitor, :series => @series, :number => 11)
  end

  context "when string format is correct and competitor is found" do
    describe "successfull save" do
      before do
        @qs = UnfinishedCompetitorQuickSave.new(@race.id, '11,dns')
      end

      describe "#save" do
        it "should save given status for the competitor and return true" do
          expect(@qs.save).to be_truthy
          @c2.reload
          expect(@c2.no_result_reason).to eq(Competitor::DNS)
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
          @qs = UnfinishedCompetitorQuickSave.new(@race.id, '++10,dnf')
        end

        describe "#save" do
          it "should save given no result reason for the competitor and return true" do
            expect(@qs.save).to be_truthy
            @c.reload
            expect(@c.no_result_reason).to eq(Competitor::DNF)
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

  describe "unknown competitor" do
    before do
      another_race = create(:race)
      series = create(:series, :race => another_race)
      create(:competitor, :series => series, :number => 8)
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
      @c = create(:competitor, :series => @series, :number => 12,
        :no_result_reason => Competitor::DQ)
      @qs = UnfinishedCompetitorQuickSave.new(@race.id, '12,dq')
    end

    it "should cause failed save" do
      check_failed_save @qs, /talletettu/, true, @c, Competitor::DQ
    end
  end

  context 'when # is used instead of ,' do
    context 'and input is valid' do
      it 'saves result' do
        @qs = UnfinishedCompetitorQuickSave.new(@race.id, '11#dq')
        expect(@qs.save).to be_truthy
        expect(@c2.reload.no_result_reason).to eq(Competitor::DQ)
      end
    end
  end

  def check_failed_save(qs, error_regex, find_competitor,
      original_competitor=nil, original_reason=nil)
    expect(qs.save).to be_falsey
    expect(qs.error).to match(error_regex)
    expect(qs.competitor).to be_nil unless find_competitor
    if original_competitor
      original_competitor.reload
      expect(original_competitor.no_result_reason).to eq(original_reason)
    end
  end
end
