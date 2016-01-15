class Team < ActiveRecord::Base
  ALLOWED_MONSTERS_COUNT = 3
  belongs_to :user, counter_cache: true
  has_many :monsters, dependent: :nullify

  validates :name, presence: true, uniqueness: {scope: :user_id}
  validate :available_teams, on: :create

  def allows_new_monster?
    monsters_count < ALLOWED_MONSTERS_COUNT
  end

  private
  def available_teams
    unless user.allows_new_team?
      errors.add(:base, 'Reached the number of teams')
    end
  end
end
