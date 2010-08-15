require 'spec_helper'

describe Competitor do
  describe "create" do
    it "should create competitor with valid attrs" do
      Factory.create(:competitor)
    end
  end

  describe "validation" do
    it "should require first_name" do
      Factory.build(:competitor, :first_name => nil).
        should have(1).errors_on(:first_name)
    end

    it "should require last_name" do
      Factory.build(:competitor, :last_name => nil).
        should have(1).errors_on(:last_name)
    end

    describe "year_of_birth" do
      it "should be mandatory" do
        Factory.build(:competitor, :year_of_birth => nil).
          should have(1).errors_on(:year_of_birth)
      end

      it "should be integer, not string" do
        Factory.build(:competitor, :year_of_birth => 'xyz').
          should have(1).errors_on(:year_of_birth)
      end

      it "should be integer, not decimal" do
        Factory.build(:competitor, :year_of_birth => 23.5).
          should have(1).errors_on(:year_of_birth)
      end

      it "should be greater than 1900" do
        Factory.build(:competitor, :year_of_birth => 1899).
          should have(1).errors_on(:year_of_birth)
      end

      it "should be less than 2100" do
        Factory.build(:competitor, :year_of_birth => 2101).
          should have(1).errors_on(:year_of_birth)
      end
    end
  end
end
