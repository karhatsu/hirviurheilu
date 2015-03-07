require 'spec_helper'

describe ApplicationHelper do

  describe "#full_name" do
    specify { expect(helper.full_name(instance_double(Competitor, :last_name => "Tester",
        :first_name => "Tim"))).to eq("Tester Tim") }

    describe "first name first" do
      specify { expect(helper.full_name(instance_double(Competitor, :last_name => "Tester",
          :first_name => "Tim"), true)).to eq("Tim Tester") }
    end
  end

  describe "#yes_or_empty" do
    context "when boolean is true" do
      it "should return yes icon" do
        expect(helper.yes_or_empty('test')).to match(/<img.* src=.*icon_yes.gif.*\/>/)
      end
    end

    context "when boolean is false" do
      it "should return html space when no block given" do
        expect(helper.yes_or_empty(nil)).to eq('&nbsp;')
      end

      it "should call block when block given" do
        s = double(Series)
        expect(s).to receive(:id)
        helper.yes_or_empty(false) do s.id end
      end
    end
  end

  describe "#value_or_space" do
    it "should return value when value is available" do
      expect(helper.value_or_space('test')).to eq('test')
    end

    it "should return html space when value not available" do
      expect(helper.value_or_space(nil)).to eq('&nbsp;')
      expect(helper.value_or_space(false)).to eq('&nbsp;')
    end
  end

  describe "#start_days_form_field" do
    before do
      @f = double(String)
      @race = instance_double(Race, :start_date => '2010-12-20')
      @series = instance_double(Series, :race => @race)
    end

    context "when only one start day" do
      it "should return hidden field with value 1" do
        expect(@series).to receive(:start_day=).with(1)
        expect(@f).to receive(:hidden_field).with(:start_day).and_return("input")
        allow(@race).to receive(:days_count).and_return(1)
        expect(helper.start_days_form_field(@f, @series)).to eq("input")
      end
    end

    context "when more than one day" do
      it "should return dropdown menu with different dates" do
        expect(@series).to receive(:start_day).and_return(2)
        options = options_for_select([['20.12.2010', 1], ['21.12.2010', 2]], 2)
        expect(@f).to receive(:select).with(:start_day, options).and_return("select")
        allow(@race).to receive(:days_count).and_return(2)
        expect(helper.start_days_form_field(@f, @series)).to eq("select")
      end
    end
  end

  describe "#offline?" do
    it "should return true when Mode.offline? returns true" do
      allow(Mode).to receive(:offline?).and_return(true)
      expect(helper).to be_offline
    end

    it "should return true when Mode.offline? returns false" do
      allow(Mode).to receive(:offline?).and_return(false)
      expect(helper).not_to be_offline
    end
  end

  describe "#link_with_protocol" do
    it "should return the given link if it starts with http://" do
      expect(helper.link_with_protocol('http://www.test.com')).to eq('http://www.test.com')
    end

    it "should return the given link if it starts with https://" do
      expect(helper.link_with_protocol('https://www.test.com')).to eq('https://www.test.com')
    end

    it "should return http protocol + the given link if the protocol is missing" do
      expect(helper.link_with_protocol('www.test.com')).to eq('http://www.test.com')
    end
  end

  describe "#competition_icon" do
    context "when single race" do
      it "should be image tag for competition's sport's lower case key with _icon.gif suffix" do
        sport = instance_double(Sport, :key => 'RUN', :initials => 'HJ')
        expect(helper).to receive(:image_tag).with("run_icon.gif", alt: 'HJ', class: 'competition_icon').and_return("image")
        expect(helper.competition_icon(instance_double(Race, :sport => sport))).to eq("image")
      end
    end
    
    context "when cup" do
      it "should be image tag for cup's sport's lower case key with _icon_cup.gif suffix" do
        sport = build :sport, key: 'SKI'
        expect(sport).to receive(:initials).and_return('HH')
        expect(helper).to receive(:image_tag).with("ski_icon_cup.gif", alt: 'HH', class: 'competition_icon').and_return("cup-image")
        cup = build :cup
        allow(cup).to receive(:sport).and_return(sport)
        expect(helper.competition_icon(cup)).to eq("cup-image")
      end
    end
  end
  
  describe "#facebook_env?" do
    it "should be true for development" do
      allow(Rails).to receive(:env).and_return('development')
      expect(helper.facebook_env?).to be_truthy
    end
    
    it "should be true for production" do
      allow(Rails).to receive(:env).and_return('production')
      expect(helper.facebook_env?).to be_truthy
    end
    
    it "should be false for all others" do
      allow(Rails).to receive(:env).and_return('test')
      expect(helper.facebook_env?).to be_falsey
    end
  end

  describe "#organizer_info_with_possible_link" do
    context "when no home page, organizer or phone" do
      it "should return nil" do
        race = build(:race, home_page: '', organizer: '', organizer_phone: '')
        expect(helper.organizer_info_with_possible_link(Race.new)).to be_nil
      end
    end
    
    context "when only organizer" do
      it "should return organizer name" do
        race = build(:race, home_page: '', organizer: 'Organizer')
        expect(helper.organizer_info_with_possible_link(race)).to eq('Organizer')
      end
    end
    
    context "when only home page" do
      it "should return link to home page with static text" do
        race = build(:race, home_page: 'www.home.com', organizer: '')
        expected_link = '<a href="http://www.home.com" target="_blank">' + t("races.show.race_home_page") + '</a>'
        expect(helper.organizer_info_with_possible_link(race)).to eq(expected_link)
      end
    end
    
    context "when only phone" do
      it "should return phone" do
        race = build(:race, home_page: '', organizer: '', organizer_phone: '123 456')
        expect(helper.organizer_info_with_possible_link(race)).to eq('123 456')
      end
    end
      
    context "when organizer and phone" do
      it "should return organizer name appended with phone" do
        race = build(:race, home_page: nil, organizer: 'Organizer', organizer_phone: '123 456')
        expected_link = 'Organizer, 123 456'
        expect(helper.organizer_info_with_possible_link(race)).to eq(expected_link)
      end
    end
      
    context "when home page, organizer and phone" do
      it "should return link to home page with organizer as text, appended with phone" do
        race = build(:race, home_page: 'http://www.home.com', organizer: 'Organizer', organizer_phone: '123 456')
        expected_link = '<a href="http://www.home.com" target="_blank">Organizer</a>, 123 456'
        expect(helper.organizer_info_with_possible_link(race)).to eq(expected_link)
      end
    end
  end

  describe '#races_drop_down_array' do
    let(:race1) { build :race, id: 1, name: 'Race 1', location: 'Location 1' }
    let(:race2) { build :race, id: 2, name: 'Race 2', location: 'Location 2' }
    let(:races) { [race1, race2] }

    it 'should return array containing elements with race info in first element, race id in second' do
      allow(helper).to receive(:race_date_interval).and_return('Dates')
      expect(helper.races_drop_down_array(races)).to eq [['Race 1 (Dates, Location 1)', 1],
                                                         ['Race 2 (Dates, Location 2)', 2]]
    end
  end
end
