require 'spec_helper'

describe RaceRight do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:race) }
  end
end