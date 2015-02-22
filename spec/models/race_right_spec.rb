require 'spec_helper'

describe RaceRight do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:race) }
    it { is_expected.to belong_to(:club) }
  end
end