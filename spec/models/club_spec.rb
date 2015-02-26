require 'spec_helper'

describe Club do
  describe "create" do
    it "should create club with valid attrs" do
      create(:club)
    end
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.not_to validate_presence_of(:long_name) }
    it { is_expected.to allow_value(nil).for(:long_name) }

    describe "unique name" do
      before do
        create(:club, :long_name => 'Long name')
      end
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:race_id) }
      it { is_expected.to validate_uniqueness_of(:long_name).scoped_to(:race_id) }

      it "should allow two nil long names for same race" do
        club = create(:club, :long_name => nil)
        expect(build(:club, :long_name => nil, :race_id => club.race.id)).
          to be_valid
      end

      it "should convert empty strings to nils for long names" do
        club = create(:club, :long_name => '')
        expect(club.long_name).to be_nil
        expect(build(:club, :long_name => '', :race_id => club.race.id)).
          to be_valid
      end
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:race) }
    it { is_expected.to have_many(:competitors) }
    it { is_expected.to have_many(:race_rights) }
  end
  
  describe "#can_be_removed?" do
    context "when club has no competitors" do
      context "and no-one has official rights for this club only" do
        it "should return true" do
          expect(Club.new.can_be_removed?).to be_truthy
        end
      end
      
      context "but someone has official rights for this club only" do
        before do
          race = create(:race)
          @club = create(:club, :race => race)
          user = create(:user)
          RaceRight.create(:race => race, :user => user, :only_add_competitors => true, :club => @club)
          @club.reload
        end
        
        it "should return false" do
          expect(@club.can_be_removed?).to be_falsey
        end
      end
    end

    context "when club has competitors" do
      before do
        @club = create(:club)
        competitor = create(:competitor, :club => @club)
        @club.reload
        expect(@club.competitors.size).to eq(1)
      end

      it "should return false" do
        expect(@club.can_be_removed?).to be_falsey
      end
    end
  end

  describe "removal" do
    before do
      @club = create(:club)
    end
    
    context "when can be done" do
      it "should remove the club" do
        expect(@club).to receive(:can_be_removed?).and_return(true)
        @club.destroy
        expect(@club).to be_destroyed
      end
    end

    context "when cannot be done" do
      it "should provide an error but not remove the club" do
        expect(@club).to receive(:can_be_removed?).and_return(false)
        @club.destroy
        expect(@club).not_to be_destroyed
      end
    end
  end

  describe "#result_name" do
    it "should return long name when long name set" do
      club = create(:club, :name => 'PS', :long_name => 'Pohjois-Savo')
      expect(club.expanded).to eq('Pohjois-Savo')
    end

    it "should return name when long name not set" do
      club = create(:club, :name => 'PS')
      expect(club.expanded).to eq('PS')
    end
  end
end
