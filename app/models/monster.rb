class Monster < ActiveRecord::Base
  CATEGORIES = %w(fire water earth electric wind)
  belongs_to :user, counter_cache: true
  belongs_to :team, counter_cache: true

  validates :name, presence: true, uniqueness: {scope: :user_id}
  validates :user_id, presence: true
  validates :power, presence: true
  validates :category, presence: true, inclusion: {in: CATEGORIES}
  validate :available_monsters, on: :create
  validate :team_size

  private

  def team_size
    if team && !team.allows_new_monster?
      errors.add(:base, 'Team size limit exceeded')
    end
  end

  def available_monsters
    unless user.allows_new_monster?
      errors.add(:base, 'Reached the number of monsters')
    end
  end
end
