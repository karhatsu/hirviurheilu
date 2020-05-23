shared_examples_for 'non-negative decimal' do |attribute|
  it { should validate_numericality_of(attribute) }
  it { should_not allow_value(-1).for(attribute) }
  it { should allow_value(0.1).for(attribute) }
  it { should allow_value(0).for(attribute) }
end

shared_examples_for 'positive decimal' do |attribute|
  it { should validate_numericality_of(attribute) }
  it { should_not allow_value(-1).for(attribute) }
  it { should_not allow_value(0).for(attribute) }
  it { should allow_value(0.1).for(attribute) }
end

shared_examples_for 'non-negative integer' do |attribute, allow_nil|
  it { should validate_numericality_of(attribute) }
  it { should_not allow_value(-1).for(attribute) }
  it { should allow_value(0).for(attribute) }
  it { should_not allow_value(1.1).for(attribute) }
  if allow_nil
    it { should allow_value(nil).for(attribute) }
  else
    it { should_not allow_value(nil).for(attribute) }
  end
end

shared_examples_for 'positive integer' do |attribute, allow_nil|
  it { should validate_numericality_of(attribute) }
  it { should_not allow_value(-1).for(attribute) }
  it { should_not allow_value(0).for(attribute) }
  it { should_not allow_value(1.1).for(attribute) }
  if allow_nil
    it { should allow_value(nil).for(attribute) }
  else
    it { should_not allow_value(nil).for(attribute) }
  end
end

shared_examples_for 'integer' do |attribute|
  it { should validate_numericality_of(attribute) }
  it { should allow_value(-1).for(attribute) }
  it { should allow_value(0).for(attribute) }
  it { should allow_value(1).for(attribute) }
  it { should_not allow_value(1.1).for(attribute) }
  it { should allow_value(nil).for(attribute) }
end

shared_examples_for 'shooting score input' do |attribute, sport_key, max_value|
  it { is_expected.to allow_value(nil).for(attribute) }
  it { is_expected.not_to allow_value(1.1).for(attribute) }
  it { is_expected.not_to allow_value(-1).for(attribute) }

  it "cannot be bigger than #{max_value} for #{sport_key}" do
    competitor = build :competitor
    allow(competitor).to receive(:sport).and_return(Sport.by_key(sport_key))
    competitor[attribute] = max_value
    expect(competitor).to have(0).errors_on(attribute)
    competitor[attribute] = max_value + 1
    expect(competitor).to have(1).errors_on(attribute)
  end

  it 'cannot be given if also individual shots have been defined' do
    competitor = build :competitor, shots: [1]
    allow(competitor).to receive(:sport).and_return(Sport.by_key(sport_key))
    competitor[attribute] = 25
    expect(competitor).to have(1).errors_on(:base)
  end
end
