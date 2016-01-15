describe User do
  context 'association' do
    it { should have_many(:teams) }
    it { should have_many(:monsters) }
  end

  describe '#allows_new_monster?' do
    it 'should allow' do
      user = build(:user, monsters_count: User::ALLOWED_MONSTERS_COUNT - 1)
      expect(user.allows_new_monster?).to be_truthy
    end
    it 'should  notallow' do
      user = build(:user, monsters_count: User::ALLOWED_MONSTERS_COUNT)
      expect(user.allows_new_monster?).to be_falsey
    end
  end

  describe '#allows_new_team?' do
    it 'should allow' do
      user = build(:user, teams_count: User::ALLOWED_TEAMS_COUNT - 1)
      expect(user.allows_new_team?).to be_truthy
    end
    it 'should  notallow' do
      user = build(:user, teams_count: User::ALLOWED_TEAMS_COUNT)
      expect(user.allows_new_team?).to be_falsey
    end
  end

end
