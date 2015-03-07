require 'spec_helper'

describe ApplicationHelper do

  describe "#points_print" do
    before do
      @all_competitors = true
    end

    it "should print no result reason if it is defined" do
      competitor = instance_double(Competitor, :no_result_reason => Competitor::DNS)
      allow(competitor).to receive(:points).with(@all_competitors).and_return(145)
      expect(helper.points_print(competitor, @all_competitors)).to eq(
        "<span class='explanation' title='Kilpailija ei osallistunut kilpailuun'>DNS</span>"
      )
    end

    it "should print points in case they are available" do
      competitor = instance_double(Competitor, :no_result_reason => nil,
        :series => nil)
      expect(competitor).to receive(:points).with(@all_competitors).and_return(145)
      expect(helper.points_print(competitor, @all_competitors)).to eq("145")
    end

    it "should print points in brackets if only partial points are available" do
      competitor = instance_double(Competitor, :no_result_reason => nil)
      expect(competitor).to receive(:points).with(@all_competitors).and_return(nil)
      expect(competitor).to receive(:points!).with(@all_competitors).and_return(100)
      expect(helper.points_print(competitor, @all_competitors)).to eq("(100)")
    end

    it "should print - if no points at all" do
      competitor = instance_double(Competitor, :no_result_reason => nil,
        :series => nil)
      expect(competitor).to receive(:points).with(@all_competitors).and_return(nil)
      expect(competitor).to receive(:points!).with(@all_competitors).and_return(nil)
      expect(helper.points_print(competitor, @all_competitors)).to eq("-")
    end
  end
  
  describe "#relay_time_adjustment" do
    before do
      allow(helper).to receive(:time_from_seconds).and_return('00:01')
    end

    it "should return nothing when nil given" do
      expect(helper.relay_time_adjustment(nil)).to eq("")
    end

    it "should return nothing when 0 seconds given" do
      expect(helper.relay_time_adjustment(0)).to eq("")
    end

    it "should return the html span block when 1 second given" do
      expect(helper.relay_time_adjustment(1)).to eq("(<span class='adjustment' title=\"Aika sisältää korjausta 00:01\">00:01</span>)")
    end
  end

  describe "#shot_points" do
    context "when reason for no result" do
      it "should return empty string" do
        competitor = instance_double(Competitor, :shots_sum => 88,
          :no_result_reason => Competitor::DNS)
        expect(helper.shot_points(competitor)).to eq('')
      end
    end

    context "when no shots sum" do
      it "should return dash" do
        competitor = instance_double(Competitor, :shots_sum => nil,
          :no_result_reason => nil)
        expect(helper.shot_points(competitor)).to eq("-")
      end
    end

    context "when no total shots wanted" do
      it "should return shot points" do
        competitor = instance_double(Competitor, :shot_points => 480, :shots_sum => 80,
          :no_result_reason => nil)
        expect(helper.shot_points(competitor, false)).to eq("480")
      end
    end

    context "when total shots wanted" do
      it "should return shot points and sum in brackets" do
        competitor = instance_double(Competitor, :shot_points => 480, :shots_sum => 80,
          :no_result_reason => nil)
        expect(helper.shot_points(competitor, true)).to eq("480 (80)")
      end
    end
  end

  describe "#shots_list" do
    it "should return dash when no shots sum" do
      competitor = instance_double(Competitor, :shots_sum => nil)
      expect(helper.shots_list(competitor)).to eq("-")
    end

    it "should return input total if such is given" do
      competitor = instance_double(Competitor, :shots_sum => 45, :shots_total_input => 45)
      expect(helper.shots_list(competitor)).to eq(45)
    end

    it "should return comma separated list if individual shots defined" do
      shots = [10, 1, 9, 5, 5, nil, nil, 6, 4, 0]
      competitor = instance_double(Competitor, :shots_sum => 50,
        :shots_total_input => nil, :shot_values => shots)
      expect(helper.shots_list(competitor)).to eq("10,1,9,5,5,0,0,6,4,0")
    end
  end

  describe "#time_points" do
    before do
      @series = instance_double(Series, :time_points_type => Series::TIME_POINTS_TYPE_NORMAL)
    end

    context "when reason for no result" do
      it "should return empty string" do
        competitor = instance_double(Competitor, :series => @series,
          :no_result_reason => Competitor::DNS)
        expect(helper.time_points(competitor)).to eq('')
      end
    end
  
    context "when 300 points for all competitors in this series" do
      it "should return 300" do
        allow(@series).to receive(:time_points_type).and_return(Series::TIME_POINTS_TYPE_ALL_300)
        competitor = instance_double(Competitor, :series => @series, :no_result_reason => nil)
        expect(helper.time_points(competitor)).to eq(300)
      end
    end
  
    context "when no time" do
      it "should return dash" do
        competitor = instance_double(Competitor, :time_in_seconds => nil,
          :no_result_reason => nil, :series => @series)
        expect(helper.time_points(competitor)).to eq("-")
      end
    end
  
    context "when time points and time wanted" do
      it "should return time points and time in brackets" do
        all_competitors = true
        competitor = instance_double(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(all_competitors).and_return(270)
        expect(helper).to receive(:time_from_seconds).with(2680).and_return("45:23")
        expect(helper.time_points(competitor, true, all_competitors)).to eq("270 (45:23)")
      end
  
      it "should wrap with best time span when full points" do
        all_competitors = true
        competitor = instance_double(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(all_competitors).and_return(300)
        expect(helper).to receive(:time_from_seconds).with(2680).and_return("45:23")
        expect(helper.time_points(competitor, true, all_competitors)).
          to eq("<span class='series_best_time'>300 (45:23)</span>")
      end
    end
    
    context "when time points but no time wanted" do
      it "should return time points" do
        all_competitors = true
        competitor = instance_double(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(all_competitors).and_return(270)
        expect(helper.time_points(competitor, false, all_competitors)).to eq("270")
      end
  
      it "should wrap with best time span when full points" do
        all_competitors = true
        competitor = instance_double(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(all_competitors).and_return(300)
        expect(helper.time_points(competitor, false, all_competitors)).
          to eq("<span class='series_best_time'>300</span>")
      end
    end
  end

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

  describe "#comparison_time_title" do
    before do
      @competitor = instance_double(Competitor)
      allow(@competitor).to receive(:comparison_time_in_seconds).and_return(1545)
    end

    it "should return empty string when empty always wanted" do
      expect(helper.comparison_time_title(@competitor, true, true)).to eq('')
    end

    it "should return empty string when no comparison time available" do
      allow(@competitor).to receive(:comparison_time_in_seconds).and_return(nil)
      expect(helper.comparison_time_title(@competitor, true, false)).to eq('')
    end

    it "should return space and title attribute with title and comparison time when empty not wanted" do
      expect(helper.comparison_time_title(@competitor, true, false)).to eq(" title='Vertailuaika: 25:45'")
    end

    it "should use all_competitors parameter when getting the comparison time" do
      allow(@competitor).to receive(:comparison_time_in_seconds).with(false).and_return(1550)
      expect(helper.comparison_time_title(@competitor, false, false)).to eq(" title='Vertailuaika: 25:50'")
    end
  end

  describe "#comparison_and_own_time_title" do
    context "when no time for competitor" do
      it "should return empty string" do
        competitor = instance_double(Competitor)
        allow(competitor).to receive(:time_in_seconds).and_return(nil)
        expect(helper.comparison_and_own_time_title(competitor)).to eq('')
      end
    end

    context "when no comparison time for competitor" do
      it "should return space and title attribute with time title and time" do
        competitor = instance_double(Competitor)
        expect(competitor).to receive(:time_in_seconds).and_return(123)
        expect(competitor).to receive(:comparison_time_in_seconds).with(false).and_return(nil)
        expect(helper).to receive(:time_from_seconds).with(123).and_return('1:23')
        expect(helper.comparison_and_own_time_title(competitor)).to eq(" title='Aika: 1:23'")
      end
    end

    context "when own and comparison time available" do
      it "should return space and title attribute with time title, time, comparison time title and comparison time" do
        competitor = instance_double(Competitor)
        expect(competitor).to receive(:time_in_seconds).and_return(123)
        expect(competitor).to receive(:comparison_time_in_seconds).with(false).and_return(456)
        expect(helper).to receive(:time_from_seconds).with(123).and_return('1:23')
        expect(helper).to receive(:time_from_seconds).with(456).and_return('4:56')
        expect(helper.comparison_and_own_time_title(competitor)).to eq(" title='Aika: 1:23. Vertailuaika: 4:56.'")
      end
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

  describe "#national_record" do
    before do
      @competitor = instance_double(Competitor)
      @race = instance_double(Race)
      series = instance_double(Series)
      allow(@competitor).to receive(:series).and_return(series)
      allow(series).to receive(:race).and_return(@race)
    end

    context "when race finished" do
      before do
        allow(@race).to receive(:finished?).and_return(true)
      end

      context "when national record passed" do
        it "should return SE" do
          allow(@competitor).to receive(:national_record_passed?).and_return(true)
          expect(helper.national_record(@competitor, true)).to eq('SE')
        end
      end

      context "when national record reached" do
        it "should return SE(sivuaa)" do
          allow(@competitor).to receive(:national_record_passed?).and_return(false)
          allow(@competitor).to receive(:national_record_reached?).and_return(true)
          expect(helper.national_record(@competitor, true)).to eq('SE(sivuaa)')
        end
      end
    end

    context "when race not finished" do
      before do
        allow(@race).to receive(:finished?).and_return(false)
      end

      context "when national record passed" do
        it "should return SE?" do
          allow(@competitor).to receive(:national_record_passed?).and_return(true)
          expect(helper.national_record(@competitor, true)).to eq('SE?')
        end
      end

      context "when national record reached" do
        it "should return SE(sivuaa)?" do
          allow(@competitor).to receive(:national_record_passed?).and_return(false)
          allow(@competitor).to receive(:national_record_reached?).and_return(true)
          expect(helper.national_record(@competitor, true)).to eq('SE(sivuaa)?')
        end
      end
    end

    context "with decoration" do
      it "should surround text with span and link" do
        allow(@race).to receive(:finished?).and_return(true)
        allow(@competitor).to receive(:national_record_passed?).and_return(true)
        expect(helper.national_record(@competitor, false)).to eq("<span class='explanation'><a href=\"" + NATIONAL_RECORD_URL + "\">SE</a></span>")
      end
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
