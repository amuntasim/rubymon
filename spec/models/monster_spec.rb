require 'rails_helper'

RSpec.describe Monster, type: :model do
  before do
    allow_any_instance_of(Monster).to receive(:user).and_return(build_stubbed(:user))
  end
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:power) }
    it { should validate_presence_of(:category) }
    it { should validate_inclusion_of(:category).in_array(Monster::CATEGORIES) }

    describe "uniqueness" do
      subject { FactoryGirl.build(:monster) }
      it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
    end
  end

  context 'association' do
    it { should belong_to(:user).counter_cache(true) }
    it { should belong_to(:team).counter_cache(true) }
  end

  describe 'create' do
    it "should allow if less than the limit" do
      allow_any_instance_of(User).to receive(:allows_new_monster?).and_return(true)
      monster = build(:monster)
      expect(monster.valid?).to be_truthy
    end

    it "should not allow if limit crossed" do
      allow_any_instance_of(User).to receive(:allows_new_monster?).and_return(false)
      monster = build(:monster)
      expect(monster.valid?).to be_falsey
    end
  end

  describe 'team assignment' do
    before do
      allow_any_instance_of(User).to receive(:allows_new_monster?).and_return(true)
      allow_any_instance_of(Monster).to receive(:team).and_return(build_stubbed(:team))
    end

    it "should allow if less than team size limit" do
      allow_any_instance_of(Team).to receive(:allows_new_monster?).and_return(true)
      monster = build(:monster)
      expect(monster.valid?).to be_truthy
    end
    it "should allow if less than team size crossed" do
      allow_any_instance_of(Team).to receive(:allows_new_monster?).and_return(false)
      monster = build(:monster)
      expect(monster.valid?).to be_falsey
    end
  end

end
