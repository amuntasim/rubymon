require 'rails_helper'

RSpec.describe Team, type: :model do
  before do
    allow_any_instance_of(Team).to receive(:user).and_return(build_stubbed(:user))
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    describe "uniqueness" do
      subject { FactoryGirl.build(:team) }
      it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
    end
  end

  context 'association' do
    it { should belong_to(:user).counter_cache(true) }
    it { should have_many(:monsters).dependent(:nullify) }
  end

  describe 'create' do
    it "should allow if less than the limit" do
      allow_any_instance_of(User).to receive(:allows_new_team?).and_return(true)
      team = build(:team)
      expect(team.valid?).to be_truthy
    end

    it "should not allow if limit crossed" do
      allow_any_instance_of(User).to receive(:allows_new_team?).and_return(false)
      team = build(:team)
      expect(team.valid?).to be_falsey
    end
  end
end
