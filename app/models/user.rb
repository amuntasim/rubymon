class User < ActiveRecord::Base
  ALLOWED_MONSTERS_COUNT = 20
  ALLOWED_TEAMS_COUNT = 3

  has_many :monsters
  has_many :teams

  def allows_new_monster?
    monsters_count < ALLOWED_MONSTERS_COUNT
  end

  def allows_new_team?
    teams_count < ALLOWED_TEAMS_COUNT
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
      end
    end
  end

end
