require 'spec_helper'

describe RaceRight do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:race) }
    it { should belong_to(:club) }
  end
end