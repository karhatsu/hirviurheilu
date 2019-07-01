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

shared_examples_for 'non-negative integer' do |attribute|
  it { should validate_numericality_of(attribute) }
  it { should_not allow_value(-1).for(attribute) }
  it { should allow_value(0).for(attribute) }
  it { should_not allow_value(1.1).for(attribute) }
end

shared_examples_for 'positive integer' do |attribute|
  it { should validate_numericality_of(attribute) }
  it { should_not allow_value(-1).for(attribute) }
  it { should_not allow_value(0).for(attribute) }
  it { should_not allow_value(1.1).for(attribute) }
end

shared_examples_for 'integer' do |attribute|
  it { should validate_numericality_of(attribute) }
  it { should allow_value(-1).for(attribute) }
  it { should allow_value(0).for(attribute) }
  it { should allow_value(1).for(attribute) }
  it { should_not allow_value(1.1).for(attribute) }
  it { should allow_value(nil).for(attribute) }
end
